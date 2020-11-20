
json.array! @my_lists.each do |my_list|
  json.title my_list.title
  json.notes do
    json.array! my_list.my_list_notes.each do |my_list_note|
      json.index my_list_note.index
      json.title my_list_note.note.title
      json.nickname my_list_note.note.user.nickname
      json.tags do
        json.array! my_list_note.note.tags.each do |tag|
          json.id tag.id
          json.name tag.name
        end
      end
    end
  end
end

json.array! @my_list_notes.each do |my_list_note|
  json.notes do
    json.array! my_list_note.my_list_notes.each do |my_list_note|
      json.title my_list_note.note.title
      json.category my_list_note.note.category_id
      json.text my_list_note.note.text
      json.tags do
        json.array! my_list_note.note.tags.each do |tag|
          json.id tag.id
          json.name tag.name
        end
      end
    end
  end
end
