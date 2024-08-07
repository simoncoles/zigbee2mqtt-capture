class RenameTypeToDeviceTypeInDevices < ActiveRecord::Migration[7.2]
  def change
    rename_column :devices, :type, :device_type
  end
end
