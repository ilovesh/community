class AddActionIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :action_id, :integer
  end
end