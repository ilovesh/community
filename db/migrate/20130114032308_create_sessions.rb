class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :course_id
      t.datetime :start_date
      t.datetime :final_date
      t.integer :duration

      t.timestamps
    end
  end
end
