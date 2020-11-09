class AddReferencesToCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :notes, :category, null: false, foreign_key: true
  end
end
