class CreateDeletedNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :deleted_notes do |t|
      t.uuid :guid, null: false, unique: true
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
