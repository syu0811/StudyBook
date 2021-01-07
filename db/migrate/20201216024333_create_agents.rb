class CreateAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :agents do |t|
      t.references :user, foreign_key: true, null: false
      t.string :token, index: true, null: false
      t.uuid :guid, null: false, unique: true, index: true
      t.timestamps
    end
  end
end
