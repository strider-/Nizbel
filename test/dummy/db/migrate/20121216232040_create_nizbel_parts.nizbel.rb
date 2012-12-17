# This migration comes from nizbel (originally 20121216231714)
class CreateNizbelParts < ActiveRecord::Migration
  def change
    create_table :nizbel_parts do |t|
      t.integer :binary_id
      t.string :message_id
      t.integer :article_id
      t.integer :part_number
      t.integer :size

      t.timestamps
    end
  end
end
