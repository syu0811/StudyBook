CSV.foreach('db/seeds/development/csv/notes.csv', headers: true) do |row|
  note = Note.new(
    title: row['title'],
    text: row['text'],
    category: Category.find_by!(name: row['category']),
    file_path: row['file_path'],
    user: User.first,
  )

  puts "note_save_error: #{note.errors}" unless note.save
end
