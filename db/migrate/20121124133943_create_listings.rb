class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :list_id
      t.integer :course_id

      t.timestamps
    end
  end
end
