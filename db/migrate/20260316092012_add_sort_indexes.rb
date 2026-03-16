class AddSortIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :devices, :last_heard_from
    add_index :devices, :manufacturer_name
    add_index :devices, :model
    add_index :devices, :power_source
    add_index :readings, :value
  end
end
