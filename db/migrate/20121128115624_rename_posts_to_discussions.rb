class RenamePostsToDiscussions < ActiveRecord::Migration
  def change
    rename_table :posts, :discussions
  end
end
