CSV.foreach("db/seeds/#{Rails.env}/csv/tags.csv", headers: true) do |row|
  tag = Tag.new(
    name: row['name'],
  )

  puts "tag_save_error: #{tag.errors}" unless tag.save
end
