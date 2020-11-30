json.array! @my_lists.each do |my_list|
  json.id my_list.id
  json.title my_list.title
  json.category_id my_list.category_id
  json.description my_list.description
  json.notes do
    json.array! my_list.my_list_notes.each do |my_list_note|
      json.id my_list_note.note_id
      json.index my_list_note.index
      json.title my_list_note.note.title
      json.nickname my_list_note.note.user.nickname
      json.category_id my_list_note.note.category_id
      json.body my_list_note.note.body
      json.tags do
        json.array! my_list_note.note.tags.each do |tag|
          json.id tag.id
          json.name tag.name
        end
      end
    end
  end
end
