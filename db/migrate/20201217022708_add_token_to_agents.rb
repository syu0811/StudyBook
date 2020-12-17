class AddTokenToAgents < ActiveRecord::Migration[6.0]
  def change
    add_column :agents, :token, :string
  end
end
