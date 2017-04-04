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
      @data_rentals = @data["VehVendorAvails"]["VehVendorAvail"]
      raise

      if !@data_rentals =[]
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
