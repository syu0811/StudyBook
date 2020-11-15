json.lists do
  json.array! @list, :id, :user_id, :category_id, :title, :description
end

json.notes do
  json.array! @my_list_notes, :id, :my_list_id, :index
end