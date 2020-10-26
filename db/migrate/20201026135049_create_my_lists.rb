class CreateMyLists < ActiveRecord::Migration[6.0]
  def change
    create_table :my_lists do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.timestamps
    end

    enable_extension 'pgroonga'
    add_index :my_lists, [:title, :description], using: :pgroonga
  end
end
