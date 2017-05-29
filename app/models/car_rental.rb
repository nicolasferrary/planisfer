class CarRental < ApplicationRecord

  monetize :price_cents

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
      sipp = data_rental["VehAvailCore"]["RentalRate"]["Vehicle"]["VehType"][0]
      car_rental.category = extract_category_from_sabre(data_rental, sipp)
      car_rental.car_name = extract_car_name_from_sipp(sipp)
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

    def extract_category_from_sabre(data_rental, sipp)
      category = extract_category(sipp)
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
      sipp = result_car["vehicle_info"]["acriss_code"][0]
      car_rental.category = extract_category_from_amadeus(result_car, sipp)
      car_rental.car_name = extract_car_name_from_sipp(sipp)
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

    def extract_category_from_amadeus(result_car, sipp)
      category = extract_category(sipp)
    end

    def extract_car_name_from_sipp(sipp)
      Constants::CAR_NAME[sipp.first(2)][0]
    end


    def extract_category(sipp)
      sipp_to_category = {
        "M" => "Mini",
        "N" => "Mini",
        "E" => "Economy",
        "H" => "Economy",
        "C" => "Compact",
        "D" => "Compact",
        "I" => "Intermediate",
        "J" => "Intermediate",
        "S" => "Intermediate",
        "R" => "Intermediate",
        "F" => "Fullsize",
        "G" => "Fullsize",
        "P" => "Premium",
        "L" => "Premium",
        "W" => "Premium",
        "O" => "Fullsize",
        "X" => "Special",
      }
      category = sipp_to_category[sipp[0]]
    end

  end

end
