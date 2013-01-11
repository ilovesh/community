class RenameActivityToActionTypeNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :activity, :action_type
    rename_column :notifications, :referrer_id, :action_user_id
  end
end