class CreateTeachings < ActiveRecord::Migration
  def change
    create_table :teachings do |t|
      t.integer :university_id
      t.integer :course_id

      t.timestamps
    end
  end
end
