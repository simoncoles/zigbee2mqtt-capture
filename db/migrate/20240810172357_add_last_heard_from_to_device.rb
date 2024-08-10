class AddLastHeardFromToDevice < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :last_heard_from, :datetime
  end
end
