class CarRental < ApplicationRecord
  belongs_to :car
  has_many :trips
  belongs_to :selection


  class << self
    def create(data, data_rental, pick_up_date_time, drop_off_date_time)
      car_rental = CarRental.new
      car_rental.price = extract_price(data_rental)
      car_rental.currency = extract_currency(data)
      car_rental.pick_up_location = extract_pick_up_address(data_rental)
      car_rental.drop_off_location = extract_drop_off_address(data_rental)
      car_rental.pick_up_date_time = pick_up_date_time
      car_rental.drop_off_date_time = drop_off_date_time
      car_rental.company = extract_company(data_rental)
      car_rental.car = extract_car(data_rental)
      car_rental.save
      car_rental
    end


    def extract_price(data_rental)
      data_rental["VehAvailCore"]["VehicleCharges"]["TotalCharge"]["Amount"].to_f
    end

    def extract_currency(data_rental)
      data_rental["VehAvailCore"]["VehicleCharges"]["TotalCharge"]["CurrencyCode"]
    end

    def extract_pick_up_address(data)
      data["VehRentalCore"]["LocationDetails"]["LocationCode"]
    end

    def extract_drop_off_address(data)
      data["VehRentalCore"]["DropOffLocationDetails"]["LocationCode"]
    end

    def extract_company(data_rental)
      data_rental["Vendor"]["CompanyShortName"]
    end

    def extract_car(data_rental)
      sipp = data_rental["VehAvailCore"]["RentalRate"]["Vehicle"]["VehType"]
      Car.find_by_sipp(sipp)
    end


  end

end
