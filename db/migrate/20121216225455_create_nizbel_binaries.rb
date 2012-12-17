class CreateNizbelBinaries < ActiveRecord::Migration
  def change
    create_table :nizbel_binaries do |t|
      t.string :name
      t.string :poster
      t.datetime :date
      t.integer :total_parts
      t.integer :group_id
      t.integer :request_id
      t.string :binary_hash
      t.integer :release_id

      t.timestamps
    end

    add_index :nizbel_binaries, :date
    add_index :nizbel_binaries, :poster
    add_index :nizbel_binaries, :binary_hash, :unique => true
  end
end
