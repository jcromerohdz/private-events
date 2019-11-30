# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "Batman",
             email: "batman@email.com")

199.times do |n|
  name  = Faker::Name.name
  email = "batman-#{n+1}@email.com"
  User.create!(name:  name,
               email: email)
end

users = User.order(:created_at).take(10)
3.times do
  name = Faker::Lorem.sentence(8)
  location = Faker::Address.city
  description = Faker::Lorem.sentence(5)
  time = Faker::Time.forward(days = 365)
  users.each { |user| user.events.create!(name: name, location: location, description: description, time: time) }
end

users = User.order(:created_at).take(10)
5.times do
  name = Faker::Lorem.sentence(8)
  location = Faker::Address.city
  description = Faker::Lorem.sentence(5)
  time = Faker::Time.backward(days = 365)
  users.each { |user| user.events.create!(name: name, location: location, description: description, time: time) }
end