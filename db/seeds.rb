# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
20.times do
  User.create!(
  email: Faker::Internet.email,
  password: "password",
  confirmed_at: Time.now,
  role: :standard
  )
end
users = User.all

100.times do
  Wiki.create!(
  user: users.sample,
  title: Faker::Lorem.sentence,
  body: Faker::Lorem.paragraph,
  private: false
  )
end
wikis = Wiki.all

puts "Seed finished."
puts "#{User.count} users created."
puts "#{Wiki.count} wikis created."
