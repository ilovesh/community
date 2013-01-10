class AddReferrerIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :referrer_id, :integer
  end
end
