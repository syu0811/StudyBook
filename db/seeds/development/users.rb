CSV.foreach('db/seeds/development/csv/users.csv', headers: true) do |row|
  user = User.new(
    firstname: row['firstname'],
    lastname: row['lastname'],
    nickname: row['nickname'],
    admin: row['admin'],
    birthdate: Date.parse(row['birthdate']),
    email: row['email'],
    password: row['password'],
    password_confirmation: row['password'],
    confirmed_at: Time.zone.now,
  )

  puts "user_save_error: #{user.errors}" unless user.save
end
