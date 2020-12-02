class CreateSubscribeMyLists < ActiveRecord::Migration[6.0]
  def change
    create_table :subscribe_my_lists do |t|
      t.references :user, foreign_key: true, null: false
      t.references :my_list, foreign_key: true, null: false
      t.timestamps
    end

    add_index :subscribe_my_lists, [:user_id, :my_list_id], unique: true
  end
end
