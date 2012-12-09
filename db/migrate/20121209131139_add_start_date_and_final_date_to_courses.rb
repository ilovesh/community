class AddStartDateAndFinalDateToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :start_date, :date
    add_column :courses, :final_date, :date
  end
end
