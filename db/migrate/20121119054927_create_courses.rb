class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :provider_id
      t.integer :status

      t.timestamps
    end
    add_index :courses, :name
  end
end
