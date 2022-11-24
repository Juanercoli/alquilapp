# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
SuperUser.destroy_all
Car.destroy_all

auto = Car.new(
      brand: "Ford",
      patent: "ABC111",
      model: "AX2010",
      vehicle_number: "1234",
      color: "Rojo"
)
auto.photo.attach(io: File.open(Rails.root.join("public/images/auto_1.jpg")), filename: "auto_1.jpg")
# esto pa la demo va servir 
Wallet.destroy_all

asd=Wallet.new(balance: -200 )

juan = User.new(
  name: "Juan",
  surname: "Ercoli",
  dni: "42675077",
  email: "a@a.com",
  phone: "2213646991",
  password: "asdasd123",
  driver_license_expiration: 5.years.from_now,
  birthdate: 22.years.ago,
  is_accepted: true,
  wallet: asd
)

juan.driver_license.attach(io: File.open(Rails.root.join("public/images/licencia_1.jpg")), filename: "licencia_1.jpg")

carlos = User.new(
  name: "Carlos",
  surname: "Brown",
  dni: "42675078",
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
  dni: "42675079",
  email: "a@c.com",
  phone: "2213646990",
  password: "asdasd123",
  driver_license_expiration: 2.years.from_now,
  birthdate: 22.years.ago,
  is_blocked: true
)

esteban.driver_license.attach(io: File.open(Rails.root.join("public/images/licencia_2.jpg")), filename: "licencia_2.jpg")

francisco = SuperUser.new(
  name: "Francisco",
  surname: "Alquilapp",
  dni: "77057625",
  email: "a@a.com",
  phone: "2213646990",
  password: "asdasd123",
  is_admin: true
)

eduardo = SuperUser.new(
  name: "Eduardo",
  surname: "Alquilapp",
  dni: "77057626",
  email: "a@b.com",
  phone: "2213646991",
  password: "asdasd123",
  is_admin: true
)

supervisor_1 = SuperUser.new(
  name: "Luna",
  surname: "Lunes",
  dni: "77057620",
  email: "b@a.com",
  phone: "2213646900",
  password: "asdasd123"
)

supervisor_2 = SuperUser.new(
  name: "Martin",
  surname: "Martes",
  dni: "77057621",
  email: "b@b.com",
  phone: "2213646901",
  password: "asdasd123"
)

supervisor_3 = SuperUser.new(
  name: "Marcos",
  surname: "Miercoles",
  dni: "77057622",
  email: "b@c.com",
  phone: "2213646902",
  password: "asdasd123"
)

supervisor_4 = SuperUser.new(
  name: "Joaquin",
  surname: "Jueves",
  dni: "77057623",
  email: "b@d.com",
  phone: "2213646903",
  password: "asdasd123"
)

supervisor_5 = SuperUser.new(
  name: "Valija",
  surname: "Viernes",
  dni: "77057624",
  email: "b@e.com",
  phone: "2213646904",
  password: "asdasd123",
  is_blocked: true
)

juan.save!
carlos.save!
esteban.save!
francisco.save!
eduardo.save!
supervisor_1.save!
supervisor_2.save!
supervisor_3.save!
supervisor_4.save!
supervisor_5.save!
auto.save!

p "Created #{User.count} users"
p "Created #{SuperUser.count} super users"
p "Created #{Car.count} cars"