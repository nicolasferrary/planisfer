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

    def obtain_rentals_sabre
      # Comment to test without calling API

      json = Rental::RentalRequester.new(
          pick_up_place: @pick_up_place,
          drop_off_place: @drop_off_place,
          pick_up_date_time: @pick_up_date_time,
          drop_off_date_time: @drop_off_date_time,
          currency: @currency
        ).make_request_sabre

      @data_sabre = JSON.parse(json)["OTA_VehAvailRateRS"]["VehAvailRSCore"]
      # # Just for tests
      @data_rentals_sabre = @data_sabre["VehVendorAvails"]["VehVendorAvail"]

      if @data_rentals_sabre != []
        car_rentals = create_car_rentals_sabre(@data_sabre, @data_rentals)
      else
        car_rentals = []
      end
      @car_rentals = car_rentals
    end

    def obtain_rentals_amadeus
      json = Rental::RentalRequester.new(
          pick_up_place: @pick_up_place,
          drop_off_place: @drop_off_place,
          pick_up_date_time: @pick_up_date_time,
          drop_off_date_time: @drop_off_date_time,
          currency: @currency
        ).make_request_amadeus
      @data_amadeus = JSON.parse(json)["results"]
      #@ata_amadeus is an array of hashes. Each hash represents one company and all its offers
      if @data_amadeus != []
        car_rentals = create_car_rentals_amadeus(@data_amadeus)
      else
        car_rentals = []
      end
      @car_rentals = car_rentals
    end

    private

    def create_car_rentals_sabre(data, data_rentals)
      car_rentals = []
      data_rentals.each do |data_rental|
        car_rental = CarRental.create_from_sabre(data, data_rental, @pick_up_date_time, @drop_off_date_time)
        car_rentals << car_rental
      end
      car_rentals
    end

    def create_car_rentals_amadeus(data)
      car_rentals = []
      data.each do |provider_results|
        #each result is all the car_rentals provided by one company
        provider_results["cars"].each do |result_car|
          car_rental = CarRental.create_from_amadeus(provider_results, result_car, @pick_up_date_time, @drop_off_date_time)
          car_rentals << car_rental
        end
      end
      car_rentals
    end

  end

end
