module Rental

  class SmartRentalAgent
    def initialize(args = {})
      @pick_up_place = args[:pick_up_place]
      @drop_off_place = args[:drop_off_place]
      @pick_up_date_time = args[:pick_up_date_time]
      @drop_off_date_time = args [:drop_off_date_time]
      @user_ip = args[:user_ip]
      @currency = args [:currency]
    end

    def obtain_rentals
      # Comment to test without calling API

      json = Rental::RentalRequester.new(
          pick_up_place: @pick_up_place,
          drop_off_place: @drop_off_place,
          pick_up_date_time: @pick_up_date_time,
          drop_off_date_time: @drop_off_date_time,
          api_key: ENV['SKYSCANNER_CAR_API_KEY'],
          user_ip: @user_ip,
          currency: @currency
        ).make_request

      @data = JSON.parse(json)["OTA_VehAvailRateRS"]["VehAvailRSCore"]

      # # Just for tests
      # @data = {"HeaderInfo"=>{"Text"=>["R C EUR RATE/PLAN MI/KM   CHG       APPROX C"]}, "VehRentalCore"=>{"NumDays"=>"7", "NumHours"=>"1", "PickUpDateTime"=>"04-25T13:50", "ReturnDateTime"=>"05-02T14:30", "DropOffLocationDetails"=>{"ExtendedLocationCode"=>"FRA", "LocationCode"=>"FRA"}, "LocationDetails"=>{"LocationCode"=>"FRA", "LocationName"=>"FRANKFURT"}}, "VehVendorAvails"=>{"VehVendorAvail"=>[{"RPH"=>"1", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"ELI", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["ECMR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"20.31", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"\u0087G", "SellGuaranteeReq"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"2.85"}, "Hour"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"7.34"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"33.97", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"ZI", "CompanyShortName"=>"AVIS", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"2", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"DTG3MC", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["MCMR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"83.45", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"11.93"}, "Hour"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"21.00"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"149.44", "CurrencyCode"=>"EUR", "RateAssured"=>"*"}}}}, "Vendor"=>{"Code"=>"ZT", "CompanyShortName"=>"THRIFTY", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"3", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"YII", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["ECMR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"96.88", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"\u0087G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"15.01"}, "Hour"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"37.55"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"162.10", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"ZD", "CompanyShortName"=>"BUDGET", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"4", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"AN7DE", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["MBMN"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"120.04", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"17.17"}, "Hour"=>{"CurrencyCode"=>"EUR"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"171.42", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"AL", "CompanyShortName"=>"ALAMO", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"5", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"ADVBWK", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["ECMR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"130.87", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"16.36"}, "Hour"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"16.64"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"192.33", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"AD", "CompanyShortName"=>"ADVANTAGE", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"6", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"NN7DE", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["MBMR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"138.05", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"19.75"}, "Hour"=>{"CurrencyCode"=>"EUR"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"197.14", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"ZL", "CompanyShortName"=>"NATIONAL", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"7", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"ADVBWK", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["HCMR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"147.88", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"18.49"}, "Hour"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"18.80"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"217.33", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"AD", "CompanyShortName"=>"ADVANTAGE", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"8", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"DTG3MC", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["CDAR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"128.79", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"18.40"}, "Hour"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"32.00"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"225.28", "CurrencyCode"=>"EUR", "RateAssured"=>"*"}}}}, "Vendor"=>{"Code"=>"ZR", "CompanyShortName"=>"DOLLAR", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"9", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"AEXWMC", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["MCMR"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"131.54", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR", "MileageAllowance"=>"UNL", "Rate"=>"18.42"}, "Hour"=>{"CurrencyCode"=>"EUR"}}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"229.34", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"ZE", "CompanyShortName"=>"HERTZ", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}, {"RPH"=>"10", "VehAvailCore"=>{"RentalRate"=>{"AvailabilityStatus"=>"S", "RateCode"=>"DLX", "STM_RatePlan"=>"W", "Vehicle"=>{"VehType"=>["MCMN"]}}, "VehicleCharges"=>{"VehicleCharge"=>{"Amount"=>"170.59", "CurrencyCode"=>"EUR", "GuaranteeInd"=>"G", "AdditionalDayHour"=>{"Day"=>{"CurrencyCode"=>"EUR"}, "Hour"=>{"CurrencyCode"=>"EUR"}}, "Commission"=>{"Amount"=>"38.99", "Percent"=>"20.000"}, "Mileage"=>{"Allowance"=>"UNL", "CurrencyCode"=>"EUR", "ExtraMileageCharge"=>".00"}, "SpecialEquipTotalCharge"=>{"CurrencyCode"=>"EUR"}, "TotalCharge"=>{"Amount"=>"281.88", "CurrencyCode"=>"EUR"}}}}, "Vendor"=>{"Code"=>"SX", "CompanyShortName"=>"SIXT", "CounterLocation"=>"I", "ParticipationLevel"=>"B"}}]}}
      @data_rentals = @data["VehVendorAvails"]["VehVendorAvail"]

      if @data_rentals != []
        car_rentals = create_car_rentals(@data, @data_rentals)
      else
        car_rentals = []
      end
      @car_rentals = car_rentals
    end

    private

    def create_car_rentals(data, data_rentals)
      car_rentals = []
      data_rentals.each do |data_rental|
        car_rental = CarRental.create(data, data_rental, @pick_up_date_time, @drop_off_date_time)
        car_rentals << car_rental
      end
      car_rentals
    end

  end

end
