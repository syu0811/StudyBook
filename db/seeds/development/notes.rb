CSV.foreach('db/seeds/development/csv/notes.csv', headers: true) do |row|
  note = Note.new(
    title: row['title'],
    text: row['text'],
    user: User.first,
  )

  puts "note_save_error: #{note.errors}" unless note.save
end
