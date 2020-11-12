json.list do
  json.merge! @my_lists.attributes
end

json.note do
  json.merge! @my_notes.attributes
end
