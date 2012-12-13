class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :name

      t.timestamps
    end
    add_index :universities, :name
  end
end
