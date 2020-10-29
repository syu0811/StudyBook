class AddReferencesToNoteTags < ActiveRecord::Migration[6.0]
  def change
    add_reference :note_tags, :note, null: false, foreign_key: true
    add_reference :note_tags, :tag, null: false, foreign_key: true
  end
end
