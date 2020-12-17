class CreateAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :agents do |t|
      t.references :users, foreign_key: true, null: false
      t.timestamps
    end
  end
end
