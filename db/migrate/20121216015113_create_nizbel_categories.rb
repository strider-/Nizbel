class CreateNizbelCategories < ActiveRecord::Migration
  def change
    create_table :nizbel_categories do |t|
      t.string :title, :null => false
      t.string :description
      t.integer :parent_id
      t.boolean :active, :default => true
    end
  end
end
