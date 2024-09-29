class CreateReadings < ActiveRecord::Migration[7.2]
  def change
    create_table :readings do |t|
      t.string :key
      t.string :value
      t.references :mqtt_message, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
