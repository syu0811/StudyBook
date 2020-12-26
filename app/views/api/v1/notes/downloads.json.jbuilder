json.notes do
  json.array! @notes do |note|
    json.guid note.guid
    json.title note.title
    json.body note.body
    json.directory_path note.directory_path
    json.category_id note.category_id
    json.tags do
      json.array! note.tags, :id, :name
    end
    json.updated_at note.updated_at.iso8601
  end
end

json.deleted_notes do
  json.array! @deleted_notes, :guid
end
