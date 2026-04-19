# Memory optimisation follow-ups

Context: the web process was repeatedly OOM-killed (7GB+ RSS) against a
Postgres DB with 4M+ `mqtt_messages`. Two fixes already landed:

1. **Removed `.includes(:mqtt_messages)` from `MonitoringController#index`** —
   that preload was pulling every message (and its TEXT columns) for every
   non-responsive device into Ruby. This was the primary OOM trigger.
2. **Dropped `mqtt_messages.formatted_json`** (migration + `ignored_columns` +
   `MqttMessage#formatted_json` derived from `content` on read). Halves row
   size across the largest table.

The two remaining items below are safe to do out-of-band; they need some
thought about scheduling, so they're parked here for a dedicated pass.

---

## 3. Stop pruning per-device on every incoming MQTT message

`MqttMessage.listen` (`app/models/mqtt_message.rb`) calls `device.prune` after
every device packet. `Device#prune` (`app/models/device.rb`) does:

```ruby
kept_message_ids = mqtt_messages.order(created_at: :desc).limit(capture_max).pluck(:id)
messages_to_delete = mqtt_messages.where.not(id: kept_message_ids)
Reading.where(mqtt_message_id: messages_to_delete.select(:id)).delete_all
messages_to_delete.delete_all
```

Problems:
- Runs on the hot ingest path — two DELETEs per packet, plus a `pluck` of up
  to `capture_max` IDs which becomes a massive `NOT IN (…)` clause.
- `capture_max` is nullable and most devices probably don't have it set, so
  the method early-returns for them — meaning the code either does nothing
  (fine) or does a lot of work on every packet (bad). It's the worst of both
  worlds.

Suggested shape:
- Remove the `device.prune` call from the listener.
- Add a periodic worker (see Procfile — could live alongside `raw_prune`)
  that iterates devices with `capture_max IS NOT NULL` once every N minutes
  and prunes each. Something like:

  ```ruby
  Device.where.not(capture_max: nil).find_each do |device|
    device.prune_in_batches
  end
  ```

- Rewrite `Device#prune` to use a cut-off `created_at` instead of a
  `NOT IN (huge list)`:

  ```ruby
  cutoff = mqtt_messages.order(created_at: :desc).offset(capture_max)
                        .limit(1).pluck(:created_at).first
  return if cutoff.nil?
  # delete in chunks (see item 4)
  ```

User will wire this into whatever scheduler they prefer (Procfile entry,
cron, Solid Queue, etc.).

## 4. Batch the bulk prune DELETEs

`MqttMessage.prune_old` and `RawMqttMessage.prune_old` both do a single
`delete_all` covering potentially millions of rows inside one transaction.
On Postgres this produces huge WAL, long locks, and stresses autovacuum.

Change to chunked deletes, e.g.:

```ruby
cutoff = prune_hours.hours.ago
loop do
  deleted = MqttMessage.where("created_at < ?", cutoff).limit(10_000).delete_all
  # also delete dependent readings in the same chunk — use the same LIMIT
  break if deleted.zero?
end
```

Readings must be deleted before their parent messages (FK) — do it in the
same chunked loop against `Reading.where(mqtt_message_id: …)`, or add
`ON DELETE CASCADE` on the FK.

Same pattern for `RawMqttMessage.prune_old`.

---

## Not yet addressed (lower priority, noted for completeness)

- `LIKE '%q%'` searches over `mqtt_messages.content` and
  `raw_mqtt_messages.payload` force sequential scans; Pagy's default `.count`
  runs that scan on every search page. Consider `pg_trgm` indexes or an
  indexed column.
- `MqttTopic.record_seen!` does three round-trips per incoming packet. Could
  be collapsed to one `UPDATE … RETURNING` once volumes justify it.
