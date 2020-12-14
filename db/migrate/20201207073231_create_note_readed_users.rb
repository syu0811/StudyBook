class CreateNoteReadedUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :note_readed_users do |t|
      t.references :note, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :note_readed_users, [:note_id, :user_id], unique: true
  end
end
