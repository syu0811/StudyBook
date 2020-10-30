class AddPgroonga < ActiveRecord::Migration[6.0]
  def change
    enable_extension('pgroonga')
  end
end
