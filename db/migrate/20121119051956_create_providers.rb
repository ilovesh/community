class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :website

      t.timestamps
    end
    add_index :providers, :name
  end
end
