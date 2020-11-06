CSV.foreach('db/seeds/development/csv/my_lists.csv', headers: true) do |row|
  my_list = MyList.new(
    title: row['title'],
    description: row['description'],
    user: User.first,
    category: Category.find_by(name: row['category_name']),
  )

  if my_list.save
    Note.all.limit(5).each do |note|
      my_list.my_list_notes.create(note: note)
    end
  else
    puts "my_list_save_error: #{my_list.errors}"
  end
end
