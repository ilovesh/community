class AddCodeAndImageLinkToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :code, :string
    add_column :courses, :image_link, :string
  end
end
