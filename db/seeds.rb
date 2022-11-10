# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all

juan = User.new(
  name: "Juan",
  surname: "Ercoli",
  dni: "42675077",
  email: "a@a.com",
  phone: "2213646991",
  password: "asdasd123",
  driver_license_expiration: 5.years.from_now,
  birthdate: 22.years.ago,
  isAccepted: true
)

juan.driver_license.attach(io: File.open(Rails.root.join("public/images/licencia_1.jpg")), filename: "licencia_1.jpg")

carlos = User.new(
  name: "Carlos",
  surname: "Brown",
  dni: "77057624",
  email: "a@b.com",
  phone: "2213646992",
  password: "asdasd123",
  driver_license_expiration: 2.years.from_now,
  birthdate: 22.years.ago
)

carlos.driver_license.attach(io: File.open(Rails.root.join("public/images/licencia_2.jpg")), filename: "licencia_2.jpg")

esteban = User.new(
  name: "Esteban",
  surname: "Quito",
  dni: "77057625",
  email: "a@c.com",
  phone: "2213646990",
  password: "asdasd123",
  driver_license_expiration: 2.years.from_now,
  birthdate: 22.years.ago,
  isBlocked: true
)

esteban.driver_license.attach(io: File.open(Rails.root.join("public/images/licencia_2.jpg")), filename: "licencia_2.jpg")

juan.save!
carlos.save!
esteban.save!

p "Created #{User.count} users"