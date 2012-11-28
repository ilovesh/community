class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes, :force => true do |t|

      t.boolean    :vote,     :default => false,    :null => false
      t.references :voteable, :polymorphic => true, :null => false
      t.integer    :user_id
      t.timestamps

    end

    add_index :votes, [:voteable_id, :voteable_type]


    # Comment out the line below to allow multiple votes per voter on a single entity.
    add_index :votes, [:user_id, :voteable_id, :voteable_type], :unique => true, :name => 'fk_one_vote_per_user_per_entity'

  end
end
