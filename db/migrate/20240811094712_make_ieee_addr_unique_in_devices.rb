class MakeIeeeAddrUniqueInDevices < ActiveRecord::Migration[7.2]
  def change
    add_index :devices, :ieee_addr, unique: true
  end
end
