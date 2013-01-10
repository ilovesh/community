class RemoveCountFromNotifications < ActiveRecord::Migration
  def up
    remove_column :notifications, :count
  end

  def down
    add_column :notifications, :count, :integer
  end
end