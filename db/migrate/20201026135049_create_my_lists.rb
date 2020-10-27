class CreateMyLists < ActiveRecord::Migration[6.0]
  def change
    create_table :my_lists do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.timestamps
    end
  end
end
