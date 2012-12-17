class CreateNizbelReleaseRegexes < ActiveRecord::Migration
  def change
    create_table :nizbel_release_regexes do |t|
      t.text :regex, :null => false, :limit => false
      t.boolean :active, :null => false, :default => true
      t.integer :options, :null => false, :default => 0
      t.string :description
      t.integer :category_id

      t.timestamps
    end

    add_index :nizbel_release_regexes, :regex, :unique => true
  end
end
