class CarRental < ApplicationRecord
  belongs_to :car
  has_many :trips
  belongs_to :selection


  class << self

    def create_from_sabre(data, data_rental, pick_up_date_time, drop_off_date_time)
      car_rental = CarRental.new
      car_rental.price = extract_price_from_sabre(data_rental)
      car_rental.currency = extract_currency_from_sabre(data_rental)
      car_rental.pick_up_location = extract_pick_up_address_from_sabre(data)
      car_rental.drop_off_location = extract_drop_off_address_from_sabre(data)
      car_rental.pick_up_date_time = pick_up_date_time
      car_rental.drop_off_date_time = drop_off_date_time
      car_rental.company = extract_company_from_sabre(data_rental)
      car_rental.car = extract_car_from_sabre(data_rental)
      car_rental.company = extract_company_from_sabre(data_rental)
      car_rental.save
      car_rental
    end


    def extract_price_from_sabre(data_rental)
      data_rental["VehAvailCore"]["VehicleCharges"]["VehicleCharge"]["TotalCharge"]["Amount"].to_f
    end

    def extract_currency_from_sabre(data_rental)
      data_rental["VehAvailCore"]["VehicleCharges"]["VehicleCharge"]["TotalCharge"]["CurrencyCode"]
    end

    def extract_pick_up_address_from_sabre(data)
      data["VehRentalCore"]["LocationDetails"]["LocationCode"]
    end

    def extract_drop_off_address_from_sabre(data)
      data["VehRentalCore"]["DropOffLocationDetails"]["LocationCode"]
    end

    def extract_company_from_sabre(data_rental)
      data_rental["Vendor"]["CompanyShortName"]
    end

    def extract_car_from_sabre(data_rental)
      sipp = data_rental["VehAvailCore"]["RentalRate"]["Vehicle"]["VehType"]
      cars = Car.where(sipp: sipp)
      car = cars.sample
    end

    def extract_company_from_sabre(data_rental)
      data_rental["Vendor"]["CompanyShortName"]
    end



    def create_from_amadeus(result, result_car, pick_up_date_time, drop_off_date_time)
      car_rental = CarRental.new
      car_rental.price = extract_price_from_amadeus(result_car)
      car_rental.currency = extract_currency_from_amadeus(result_car)
      car_rental.pick_up_location = extract_pick_up_address_from_amadeus(result)
      car_rental.drop_off_location = extract_pick_up_address_from_amadeus(result)
      car_rental.pick_up_date_time = pick_up_date_time
      car_rental.drop_off_date_time = drop_off_date_time
      car_rental.company = extract_company_from_amadeus(result)
      car_rental.car = extract_car_from_amadeus(result_car)
      car_rental.company = extract_company_from_amadeus(result)
      car_rental.save
      car_rental
    end

    def extract_price_from_amadeus(result_car)
      result_car["estimated_total"]["amount"]
    end

    def extract_currency_from_amadeus(result_car)
      result_car["estimated_total"]["currency"]
    end

    def extract_pick_up_address_from_amadeus(result)
      result["airport"]
    end

    def extract_company_from_amadeus(result)
      result["provider"]["company_name"]
    end

    def extract_car_from_amadeus(result_car)
      sipp = result_car["vehicle_info"]["acriss_code"]
      cars = Car.where(sipp: sipp)
      if cars != []
        car = cars.sample
        if car.image_url.nil?
          car.image_url = extract_image_from_amadeus(result_car)
          car.save
        end
      end
      car
    end

    def extract_image_from_amadeus(result_car)
      result_car["images"][0]["url"] unless result_car["images"].nil?
    end

    def extract_company_from_amadeus(result)
      result["provider"]["company_name"]
    end

  end

end
