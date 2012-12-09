class AddUniversityToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :university, :string
  end
end
