class AddUrlToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :url, :string
  end
end
