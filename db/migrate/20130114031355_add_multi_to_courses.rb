class AddMultiToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :multi, :boolean, default: false
  end
end