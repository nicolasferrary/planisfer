# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Trip.destroy_all
# RoundTripFlight.destroy_all
# Region.destroy_all
# Airport.destroy_all
# City.destroy_all
# CarRental.destroy_all
# Selection.destroy_all
Car.destroy_all


# Seed of cars (1 car per mini_sipp)

sipp_hash = {
  "category" => ["M", "N", "E", "H", "C", "D", "I", "J", "S", "R", "F", "G", "P", "U", "L", "W", "O", "X"],
  "type" => ["B", "C", "D", "W", "V", "L", "S", "T", "F", "J", "X", "P", "Q", "Z", "E", "M", "R", "H", "Y", "N", "G", "K"],
  "transmission" => ["M", "N", "C", "A", "B", "D"],
  "fuel_and_ac" => ["R", "N", "D", "Q", "H", "I", "E", "C", "L", "S", "A", "B", "M", "F", "V", "Z", "U", "X"]
}

sipp_hash["category"].each do |category|
  sipp_hash["type"].each do |type|
    sipp_hash["transmission"].each do |transmission|
      sipp_hash["fuel_and_ac"].each do |fuel|
        sipp = category + type + transmission + fuel
        Car.create(sipp)
      end
    end
  end
end






