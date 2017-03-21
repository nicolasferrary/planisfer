class CarRental < ApplicationRecord
  belongs_to :car
  has_many :trips


  class << self
    def create(data, rental_data, pick_up_date_time, drop_off_date_time, driver_age)
      car_rental = CarRental.new
      car_rental.price = extract_price(rental_data)
      car_rental.currency = extract_currency(data)
      car_rental.pick_up_location = extract_pick_up_address(rental_data)
      car_rental.drop_off_location = extract_drop_off_address(rental_data)
      car_rental.pick_up_date_time = pick_up_date_time
      car_rental.drop_off_date_time = drop_off_date_time
      car_rental.driver_age = driver_age
      car_rental.company = extract_company(rental_data)
      car_rental.car = extract_car(data, rental_data)
      car_rental.deep_link_url = extract_deep_link_url(rental_data)
      car_rental.save
      car_rental
    end


    def extract_price(rental_data)
      rental_data['price_all_days'].to_f
    end

    def extract_currency(data)
      data['submitted_query']['currency']
    end

    def extract_pick_up_address(rental_data)
      rental_data['location']['pick_up']['address'] unless (rental_data['location'].nil? || rental_data['location'] == {})
    end

    def extract_drop_off_address(rental_data)
      rental_data['location']['drop_off']['address'] unless rental_data['location']['drop_off'].nil?
    end

    def extract_company(rental_data)
      rental_data['website_id']['name']
    end

    def extract_car(data, rental_data)
    #if car already exists in database
      if !Car.find_by_name(rental_data['vehicle']).nil?
        Car.find_by_name(rental_data['vehicle'])
      else
        Car.create(data, rental_data)
      end
    end

    def extract_deep_link_url(rental_data)
      rental_data['deeplink_url']
    end

  end

end
