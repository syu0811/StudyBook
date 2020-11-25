class AddIndexToNotes < ActiveRecord::Migration[6.0]
  def up
    ActiveRecord::Base.connection.execute("CREATE  INDEX index_full_text_notes ON notes USING pgroonga (id, title pgroonga_varchar_full_text_search_ops_v2, body)")
  end

  def down
    ActiveRecord::Base.connection.execute("DROP INDEX index_full_text_notes")
  end
end
