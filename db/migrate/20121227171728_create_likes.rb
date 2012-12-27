class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes, :force => true do |t|

      t.boolean    :like,     :default => false,    :null => false
      t.references :likeable, :polymorphic => true, :null => false
      t.integer    :user_id
      t.timestamps

    end

    add_index :likes, [:likeable_id, :likeable_type]
    add_index :likes, [:user_id, :likeable_id, :likeable_type], :unique => true, :name => 'fk_one_like_per_user_per_entity'

  end
end