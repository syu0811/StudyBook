class CreateMyListNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :my_list_notes do |t|
      t.references :my_list, foreign_key: true, null: false
      t.references :note, foreign_key: true, null: false
      t.integer :index, null: false
      t.timestamps
    end

    add_index :my_list_notes, [:my_list_id, :note_id], unique: true
  end
end
