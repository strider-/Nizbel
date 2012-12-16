class CreateNizbelReleaseRegexes < ActiveRecord::Migration
  def change
    create_table :nizbel_release_regexes do |t|
      t.string :regex, :null => false
      t.boolean :active, :null => false, :default => true
      t.integer :options, :null => false, :default => 0
      t.string :description

      t.timestamps
    end
  end
end
