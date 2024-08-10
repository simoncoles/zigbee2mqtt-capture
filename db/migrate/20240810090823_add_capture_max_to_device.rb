class AddCaptureMaxToDevice < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :capture_max, :integer
  end
end
