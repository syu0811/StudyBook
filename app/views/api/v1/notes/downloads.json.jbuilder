json.notes do
  json.array! @notes do |note|
    json.guid note.guid
    json.title note.title
    json.text note.text
    json.file_path note.file_path
    json.category_id note.category_id
    json.tags do
      json.array! note.tags, :id, :name
    end
  end
end

json.deleted_notes do
  json.array! @deleted_notes, :guid
end
