class CreateDevices < ActiveRecord::Migration[7.2]
  def change
    create_table :devices do |t|
      t.string :friendly_name
      t.string :ieee_addr
      t.string :manufacturer_name
      t.string :model
      t.integer :network_address
      t.string :power_source
      t.string :type
      t.integer :zcl_version

      t.timestamps
    end
  end
end
