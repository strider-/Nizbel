class CreateNizbelUsers < ActiveRecord::Migration
  def change
    create_table :nizbel_users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :role
      t.integer :nzb_grabs, :null => false, :default => 0
      t.string :token

      t.timestamps
    end
    add_index :nizbel_users, :username, :unique => true
    add_index :nizbel_users, :email, :unique => true
  end
end
