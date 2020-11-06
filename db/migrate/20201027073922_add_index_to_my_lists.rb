class AddIndexToMyLists < ActiveRecord::Migration[6.0]
  def up
    ActiveRecord::Base.connection.execute("CREATE  INDEX index_full_text_my_lists ON my_lists USING pgroonga (id, title pgroonga_varchar_full_text_search_ops_v2, description)")
  end

  def down
    ActiveRecord::Base.connection.execute("DROP INDEX index_full_text_my_lists")
  end
end
