class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :notes do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.uuid :guid, null: false, unique: true
      t.string :directory_path
      t.timestamps
    end
  end
end
