class AddCategoriesGroupsJoinTable < ActiveRecord::Migration
  def up
    create_table :categories_groups do |t|
      t.integer :group_id
      t.integer :category_id
    end
  end

  def down
    drop_table :categories_groups
  end
end
