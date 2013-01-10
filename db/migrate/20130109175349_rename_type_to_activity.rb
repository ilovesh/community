class RenameTypeToActivity < ActiveRecord::Migration
  def change
    rename_column :notifications, :type, :activity
  end
end
