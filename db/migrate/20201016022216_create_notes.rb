class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.string :text, null: false
      t.timestamps
    end
  end
end
