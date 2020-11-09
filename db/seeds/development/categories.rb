CSV.foreach('db/seeds/development/csv/categories.csv', headers: true) do |row|
  category = Category.new(
    name: row['name'],
  )

  puts "category_save_error: #{category.errors}" unless category.save
end
