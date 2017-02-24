# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Trip.destroy_all
RoundTripFlight.destroy_all
Region.destroy_all
Airport.destroy_all
City.destroy_all


city1 = City.create!(name:"Paris")
city2 = City.create!(name:"London")
city3 = City.create!(name:"Barcelona")
city4 = City.create!(name:"Milan")


region1 = Region.create!(name: "Andalucia")
region2 = Region.create!(name: "Puglia")
region3 = Region.create!(name: "Ile de France")
region4 = Region.create!(name: "Tuscany")
region5 = Region.create!(name: "Great-London")
region6 = Region.create!(name: "Catalonia")
region7 = Region.create!(name: "Lombardia")

airport1 = Airport.new(name: "CDG", iata: "CDG")
airport1.city = city1
airport1.region = region3
airport1.save
airport2 = Airport.new(name: "Orly", iata: "ORY")
airport2.city = city1
airport2.region = region3
airport2.save
airport3 = Airport.new(name: "Gatwick", iata: "LGW")
airport3.city = city2
airport3.region = region5
airport3.save
airport4 = Airport.new(name: "Heathrow", iata: "LHR")
airport4.city = city2
airport4.region = region5
airport4.save
airport5 = Airport.new(name: "Barcelona", iata: "BCN")
airport5.city = city3
airport5.region = region6
airport5.save
airport6 = Airport.new(name: "Sevilla", iata: "SVQ")
airport6.city = city3
airport6.region = region1
airport6.save
airport7 = Airport.new(name: "Malaga", iata: "AGP")
airport7.city = city2
airport7.region = region1
airport7.save
airport8 = Airport.new(name: "Florence-Peretola", iata: "FLR")
airport8.city = city4
airport8.region = region4
airport8.save
airport9 = Airport.new(name: "Pisa Galileo Galilei", iata: "PSA")
airport9.city = city4
airport9.region = region4
airport9.save
airport10 = Airport.new(name: "Malpensa", iata: "MXP")
airport10.city = city4
airport10.region = region7
airport10.save
airport11 = Airport.new(name: "Linate", iata: "LIN")
airport11.city = city4
airport11.region = region7
airport11.save
airport12 = Airport.new(name: "Bari-Palese", iata: "BRI")
airport12.city = city3
airport12.region = region2
airport12.save
airport13 = Airport.new(name: "Brindisi-casale", iata: "BDS")
airport13.city = city1
airport13.region = region2
airport13.save
airport14 = Airport.new(name: "Gerona", iata: "GRO")
airport14.city = city1
airport14.region = region6
airport14.save

round_trip_flight1 = RoundTripFlight.new(
  price: 90,
  flight1_origin_airport_iata: "CDG",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "AGP",
  flight2_destination_airport_iata: "ORY",
  flight1_take_off_at: "Mon, 13 Mar 2017 00:00:00 UTC",
  flight1_landing_at: "Mon, 13 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Fri, 24 Mar 2017 08:00:00 UTC",
  flight2_landing_at: "Fri, 24 Mar 2017 10:00:00 UTC"
  )
round_trip_flight1.save

round_trip_flight2 = RoundTripFlight.new(
  price: 100,
  flight1_origin_airport_iata: "ORY",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "SVQ",
  flight2_destination_airport_iata: "ORY",
  flight1_take_off_at: "Mon, 13 Mar 2017 00:30:00 UTC",
  flight1_landing_at: "Mon, 13 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Fri, 24 Mar 2017 08:30:00 UTC",
  flight2_landing_at: "Fri, 24 Mar 2017 10:45:00 UTC"
  )
round_trip_flight2.save

round_trip_flight3 = RoundTripFlight.new(
  price: 120,
  flight1_origin_airport_iata: "ORY",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "AGP",
  flight2_destination_airport_iata: "ORY",
  flight1_take_off_at: "Mon, 13 Mar 2017 00:30:00 UTC",
  flight1_landing_at: "Mon, 13 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Fri, 24 Mar 2017 08:30:00 UTC",
  flight2_landing_at: "Fri, 24 Mar 2017 10:45:00 UTC"
  )
round_trip_flight3.save


round_trip_flight4 = RoundTripFlight.new(
  price: 153,
  flight1_origin_airport_iata: "CDG",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "AGP",
  flight2_destination_airport_iata: "CDG",
  flight1_take_off_at: "Mon, 13 Mar 2017 03:34:00 UTC",
  flight1_landing_at: "Mon, 13 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Fri, 24 Mar 2017 06:30:00 UTC",
  flight2_landing_at: "Fri, 24 Mar 2017 10:48:00 UTC"
  )
round_trip_flight4.save

round_trip_flight5 = RoundTripFlight.new(
  price: 148,
  flight1_origin_airport_iata: "CDG",
  flight1_destination_airport_iata: "AGP",
  flight2_origin_airport_iata: "SVQ",
  flight2_destination_airport_iata: "ORY",
  flight1_take_off_at: "Mon, 13 Mar 2017 03:34:00 UTC",
  flight1_landing_at: "Mon, 13 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Fri, 24 Mar 2017 06:30:00 UTC",
  flight2_landing_at: "Fri, 24 Mar 2017 10:48:00 UTC"
  )
round_trip_flight5.save

round_trip_flight6 = RoundTripFlight.new(
  price: 90,
  flight1_origin_airport_iata: "LHR",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "AGP",
  flight2_destination_airport_iata: "LGW",
  flight1_take_off_at: "Tue, 14 Mar 2017 00:00:00 UTC",
  flight1_landing_at: "Tue, 14 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Thu, 23 Mar 2017 08:00:00 UTC",
  flight2_landing_at: "Thu, 23 Mar 2017 10:00:00 UTC"
  )
round_trip_flight6.save

round_trip_flight7 = RoundTripFlight.new(
  price: 100,
  flight1_origin_airport_iata: "LGW",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "SVQ",
  flight2_destination_airport_iata: "LGW",
  flight1_take_off_at: "Tue, 14 Mar 2017 00:30:00 UTC",
  flight1_landing_at: "Tue, 14 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Thu, 23 Mar 2017 08:30:00 UTC",
  flight2_landing_at: "Thu, 23 Mar 2017 10:45:00 UTC"
  )
round_trip_flight7.save

round_trip_flight8 = RoundTripFlight.new(
  price: 120,
  flight1_origin_airport_iata: "LGW",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "AGP",
  flight2_destination_airport_iata: "LGW",
 flight1_take_off_at: "Tue, 14 Mar 2017 00:30:00 UTC",
  flight1_landing_at: "Tue, 14 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Thu, 23 Mar 2017 08:30:00 UTC",
  flight2_landing_at: "Thu, 23 Mar 2017 10:45:00 UTC"
  )
round_trip_flight8.save


round_trip_flight9 = RoundTripFlight.new(
  price: 153,
  flight1_origin_airport_iata: "LHR",
  flight1_destination_airport_iata: "SVQ",
  flight2_origin_airport_iata: "AGP",
  flight2_destination_airport_iata: "LHR",
  flight1_take_off_at: "Tue, 14 Mar 2017 03:34:00 UTC",
  flight1_landing_at: "Tue, 14 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Thu, 23 Mar 2017 06:30:00 UTC",
  flight2_landing_at: "Thu, 23 Mar 2017 10:48:00 UTC"
  )
round_trip_flight9.save

round_trip_flight10 = RoundTripFlight.new(
  price: 148,
  flight1_origin_airport_iata: "LHR",
  flight1_destination_airport_iata: "AGP",
  flight2_origin_airport_iata: "SVQ",
  flight2_destination_airport_iata: "LGW",
  flight1_take_off_at: "Tue, 14 Mar 2017 03:34:00 UTC",
  flight1_landing_at: "Tue, 14 Mar 2017 02:00:00 UTC",
  flight2_take_off_at: "Thu, 23 Mar 2017 06:30:00 UTC",
  flight2_landing_at: "Thu, 23 Mar 2017 10:48:00 UTC"
  )
round_trip_flight10.save

round_trip_flight11 = RoundTripFlight.new(
 price: 123,
 flight1_origin_airport_iata: "LHR",
 flight1_destination_airport_iata: "BDS",
 flight2_origin_airport_iata: "BRI",
 flight2_destination_airport_iata: "LHR",
 flight1_take_off_at: "Wed, 15 Mar 2017 10:10:00 UTC",
 flight1_landing_at: "Wed, 15 Mar 2017 12:00:00 UTC",
 flight2_take_off_at: "Sat, 25 Mar 2017 18:00:00 UTC",
 flight2_landing_at: "Sat, 25 Mar 2017 18:55:00 UTC"
 )
round_trip_flight11.save

round_trip_flight12 = RoundTripFlight.new(
 price: 75,
 flight1_origin_airport_iata: "LHR",
 flight1_destination_airport_iata: "BRI",
 flight2_origin_airport_iata: "BRI",
 flight2_destination_airport_iata: "LGW",
 flight1_take_off_at: "Wed, 15 Mar 2017 12:00:00 UTC",
 flight1_landing_at: "Wed, 15 Mar 2017 14:32:00 UTC",
 flight2_take_off_at: "Sat, 25 Mar 2017 19:14:00 UTC",
 flight2_landing_at: "Sat, 25 Mar 2017 21:00:00 UTC"
 )
round_trip_flight12.save

round_trip_flight13 = RoundTripFlight.new(
 price: 88,
 flight1_origin_airport_iata: "LGW",
 flight1_destination_airport_iata: "BRI",
 flight2_origin_airport_iata: "BDS",
 flight2_destination_airport_iata: "LHR",
 flight1_take_off_at: "Wed, 15 Mar 2017 06:53:00 UTC",
 flight1_landing_at: "Wed, 15 Mar 2017 09:00:00 UTC",
 flight2_take_off_at: "Sat, 25 Mar 2017 08:42:00 UTC",
 flight2_landing_at: "Sat, 25 Mar 2017 10:20:00 UTC"
 )
round_trip_flight13.save

round_trip_flight14 = RoundTripFlight.new(
 price: 97,
 flight1_origin_airport_iata: "BCN",
 flight1_destination_airport_iata: "FLR",
 flight2_origin_airport_iata: "PSA",
 flight2_destination_airport_iata: "BCN",
 flight1_take_off_at: "Fri, 17 Mar 2017 14:19:00 UTC",
 flight1_landing_at: "Fri, 17 Mar 2017 16:06:00 UTC",
 flight2_take_off_at: "Sun, 26 Mar 2017 13:09:00 UTC",
 flight2_landing_at: "Sun, 26 Mar 2017 15:25:00 UTC"
 )
round_trip_flight14.save

round_trip_flight15 = RoundTripFlight.new(
 price: 112,
 flight1_origin_airport_iata: "BCN",
 flight1_destination_airport_iata: "FLR",
 flight2_origin_airport_iata: "FLR",
 flight2_destination_airport_iata: "BCN",
 flight1_take_off_at: "Fri, 17 Mar 2017 11:00:00 UTC",
 flight1_landing_at: "Fri, 17 Mar 2017 12:56:00 UTC",
 flight2_take_off_at: "Sun, 26 Mar 2017 16:14:00 UTC",
 flight2_landing_at: "Sun, 26 Mar 2017 18:00:00 UTC"
 )
round_trip_flight15.save


round_trip_flight16 = RoundTripFlight.new(
 price: 146,
 flight1_origin_airport_iata: "BCN",
 flight1_destination_airport_iata: "PSA",
 flight2_origin_airport_iata: "FLR",
 flight2_destination_airport_iata: "BCN",
 flight1_take_off_at: "Fri, 17 Mar 2017 16:50:00 UTC",
 flight1_landing_at: "Fri, 17 Mar 2017 19:11:00 UTC",
 flight2_take_off_at: "Sun, 26 Mar 2017 18:42:00 UTC",
 flight2_landing_at: "Sun, 26 Mar 2017 20:20:00 UTC"
 )
round_trip_flight16.save


round_trip_flight17 = RoundTripFlight.new(
 price: 76,
 flight1_origin_airport_iata: "BCN",
 flight1_destination_airport_iata: "PSA",
 flight2_origin_airport_iata: "PSA",
 flight2_destination_airport_iata: "BCN",
 flight1_take_off_at: "Fri, 17 Mar 2017 09:53:00 UTC",
 flight1_landing_at: "Fri, 17 Mar 2017 11:00:00 UTC",
 flight2_take_off_at: "Sun, 26 Mar 2017 05:42:00 UTC",
 flight2_landing_at: "Sun, 26 Mar 2017 07:20:00 UTC"
 )
round_trip_flight17.save

search1 = Search.new(
  starts_on: "Mon, 13 Mar 2017",
  returns_on: "Fri, 24 Mar 2017",
  nb_travelers: 2)
search1.city = city1
search1.region = region1
search1.save!


trip1 = Trip.new(
  starts_on: "Mon, 13 Mar 2017",
  returns_on: "Fri, 24 Mar 2017",
  nb_travelers: 2
  )
trip1.city = city1
trip1.region = region1
trip1.round_trip_flight = round_trip_flight1
trip1.price = round_trip_flight1.price
trip1.search = search1
trip1.save!

trip2 = Trip.new(
  starts_on: "Tue, 13 Mar 2017",
  returns_on: "Thu, 24 Mar 2017",
  nb_travelers: 2
  )
trip2.city = city2
trip2.region = region1
trip2.round_trip_flight = round_trip_flight7
trip2.price = round_trip_flight7.price
trip2.search = search1
trip2.save!

trip3 = Trip.new(
  starts_on: "Wed, 13 Mar 2017",
  returns_on: "Sat, 24 Mar 2017",
  nb_travelers: 2
  )
trip3.city = city2
trip3.region = region2
trip3.round_trip_flight = round_trip_flight11
trip3.price = round_trip_flight11.price
trip3.search = search1
trip3.save!

trip4 = Trip.new(
  starts_on: "Fri, 13 Mar 2017",
  returns_on: "Sun, 24 Mar 2017",
  nb_travelers: 2
  )
trip4.city = city3
trip4.region = region4
trip4.round_trip_flight = round_trip_flight16
trip4.price = round_trip_flight16.price
trip4.search = search1
trip4.save!





