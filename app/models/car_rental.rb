class CarRental < ApplicationRecord
  belongs_to :car
  has_many :trips



  class << self
    def create(rental_data, pick_up_date_time, drop_off_date_time, driver_age, car)
      car_rental = CarRental.new
      car_rental.price = extract_price(rental_data)
      car_rental.currency = extract_currency(rental_data)
      car_rental.pick_up_address = extract_pick_up_address(rental_data)
      car_rental.drop_off_address = extract_drop_off_address(rental_data)
      car_rental.pick_up_date_time = pick_up_date_time
      car_rental.drop_off_date_time = drop_off_date_time
      car_rental.driver_age = driver_age
      car_rental.company = extract_company(rental_data)
      car_rental.car = car_extract(rental_data) #différencier le cas ou la voiture existe et sinon créer une car en renvoyant à une méthode dans le modèle car
      car_rental.car = deep_link_url_extract(rental_data)
      car_rental.save
      car_rental
    end

    def extract_currency(item)
      item['saleTotal'].match(/\w{3}/).to_s
    end

    def extract_price(item)
      item['saleTotal'].match(/\d+\.*\d+/)[0].to_f
    end

    def extract_origin_airport_iata(item, slice)
      item['slice'][slice]['segment'].first['leg'].first['origin']
    end

    def extract_destination_airport_iata(item, slice)
      item['slice'][slice]['segment'].first['leg'].first['destination']
    end

    def extract_take_off_at(item, slice)
      Time.parse item['slice'][slice]['segment'].first['leg'].first['departureTime']
    end

    def extract_landing_at(item, slice)
      Time.parse item['slice'][slice]['segment'].first['leg'].first['arrivalTime']
    end

    def extract_carrier(item, slice)
      item['slice'][slice]['segment'].first['flight']['carrier']
    end

    def extract_flight_number(item, slice)
      item['slice'][slice]['segment'].first['flight']['number']
    end

  end

end
