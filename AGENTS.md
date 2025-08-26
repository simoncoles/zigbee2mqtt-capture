# Repository Guidelines

## Project Structure & Module Organization
- `app/`: Rails MVC code (`models/`, `controllers/`, `views/`, `assets/`, `javascript/`). Key: `app/models/mqtt_message.rb` (MQTT listener), `app/models/device.rb`, `app/models/reading.rb`.
- `app/madmin/`: Admin UI built with Madmin by Chris Oliver.
- `config/`: environment, routes, initializers. `config.ru` boots Rack.
- `db/`: schema and migrations; persisted in `storage/` when using SQLite.
- `bin/`: runnable scripts (`bin/dev`, `bin/rails`, `bin/rubocop`, `bin/brakeman`).
- `test/`: Minitest suites, fixtures under `test/fixtures/`.
- `Dockerfile`, `Procfile`, `.env.example`: containerization and local env.

## Build, Test, and Development Commands
- `bin/setup`: install gems and prepare app.
- `bin/dev`: start web + MQTT via Foreman (Procfile).
- `bin/rails server`: run web server only.
- `bin/rails runner "MqttMessage.listen"`: run MQTT listener only.
- `rails test` or `bin/rails test`: run all tests.
- `bin/rubocop`: lint Ruby with Omakase rules.
- `bin/brakeman`: static security scan.
- Docker run example: `docker run -e MQTT_BROKER="mqtt://user:pass@host:1883" ghcr.io/simoncoles/zigbee2mqtt-capture:main`.

## Coding Style & Naming Conventions
- Ruby: 2‑space indent, UTF‑8, one class/module per file.
- Names: Classes `CamelCase` (`MqttMessage`), files `snake_case.rb` (`mqtt_message.rb`).
- Controllers end with `Controller`; tests end with `_test.rb`.
- Lint using RuboCop (rubocop-rails-omakase). Prefer explicitness and small methods.

## Testing Guidelines
- Framework: Rails Minitest with fixtures. Place tests in `test/<area>/*_test.rb`.
- Run: `rails test` (parallelized by default). Add system tests under `test/system/` for UI.
- Aim for coverage on models and any custom services (e.g., MQTT parsing).

## Commit & Pull Request Guidelines
- Commits: short, imperative mood (e.g., "Fix env vars", "Add prune job"). Group related changes.
- PRs: clear description, linked issue (if any), steps to reproduce/verify, and screenshots for UI/admin when relevant.
- Checks: ensure `rails test`, `bin/rubocop`, and `bin/brakeman` pass locally.

## Security & Configuration Tips
- Configure via env vars: `MQTT_URL`, `MQTT_BROKER`, `DATABASE_URL`, `ZIGBEE2MQTT_BASE`, `PRUNE_HOURS`, optional `APPSIGNAL_PUSH_API_KEY`.
- Use `.env` for local only; do not commit secrets. See `.env.example`.

## Admin Interface
- Uses Madmin (by Chris Oliver, `excid3/madmin`) for the admin UI — not a Basecamp gem.
- Admin code lives in `app/madmin/`. Include screenshots in PRs when changing admin pages.
