require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Trip.destroy_all
RoundTripFlight.destroy_all
# CarRental.destroy_all
# Selection.destroy_all


# Airport.destroy_all
Poi.destroy_all
Search.destroy_all
Region.destroy_all

# Seeding all the airports with IATA codes and coordinates

csv_options = { col_sep: ';', headers: :first_row, encoding: 'ISO-8859-1'}
filepath = 'db/airports_city.csv'

CSV.foreach(filepath, csv_options) do |row|
  Airport.create!(
    name: row['name'],
    iata: row['iata'],
    coordinates: row['coordinates'],
    country: row['parent_name'],
    category: row['type'],
    cityname: row['City'],
    content: "#{row['iata']} #{row['name']}, #{row['parent_name']}"
    )
end

# Seeding all the POIs

csv_options = { col_sep: ';', headers: :first_row, encoding: 'ISO-8859-1'}
filepath = 'db/poi.csv'

CSV.foreach(filepath, csv_options) do |row|
  Poi.create!(
    name: row[0],
    location: row['location'],
    photo: row['photo'],
    title: row['title'],
    description1: row['description1'],
    description2: row['description2'],
    description3: row['description3'],
    description4: row['description4'],
    description5: row['description5']
    )
end


# Seeding all the Regions

csv_options = { col_sep: ';', headers: :first_row, encoding: 'ISO-8859-1'}
filepath = 'db/region.csv'


CSV.foreach(filepath, csv_options) do |row|
  Region.create!(
    name: row[0],
    description: row['description'],
    pois: row['poi'],
    airports: row['airports'],
    )
end

# city1 = City.create!(name:"Paris")
# city2 = City.create!(name:"London")
# city3 = City.create!(name:"Barcelona")
# city4 = City.create!(name:"Milan")


# Seed of cars (1 car per mini_sipp)
# sipp_hash = {
#   "category" => ["M", "N", "E", "H", "C", "D", "I", "J", "S", "R", "F", "G", "P", "U", "L", "W", "O", "X"],
#   "type" => ["B", "C", "D", "W", "V", "L", "S", "T", "F", "J", "X", "P", "Q", "Z", "E", "M", "R", "H", "Y", "N", "G", "K"],
#   "transmission" => ["M", "N", "C", "A", "B", "D"],
#   "fuel_and_ac" => ["R", "N", "D", "Q", "H", "I", "E", "C", "L", "S", "A", "B", "M", "F", "V", "Z", "U", "X"]
# }

# sipp_hash["category"].each do |category|
#   sipp_hash["type"].each do |type|
#     sipp_hash["transmission"].each do |transmission|
#       sipp_hash["fuel_and_ac"].each do |fuel|
#         sipp = category + type + transmission + fuel
#         Car.create(sipp)
#       end
#     end
#   end
# end








