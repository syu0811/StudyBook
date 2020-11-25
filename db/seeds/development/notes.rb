CSV.foreach('db/seeds/development/csv/notes.csv', headers: true) do |row|
  note = Note.new(
    title: row['title'],
    body: row['body'],
    category: Category.find_by!(name: row['category']),
    directory_path: row['directory_path'],
    user: User.first,
  )

  puts "note_save_error: #{note.errors}" unless note.save
end
