module Car_rental

  class SmartCarRentalAgent
    def initialize(args = {})
      @pick_up_place = args[:pick_up_place]
      @drop_off_place = args[:drop_off_place]
      @pick_up_date_time = args[:pick_up_date_time]
      @drop_off_date_time = args [:drop_off_date_time]
      @driver_age = args[:driver_age]
      @user_ip = args[:user_ip]
      @currency = args [:currency]
    end

    def obtain_offers
      json = Car_rental::CarRentalRequester.new(
          pick_up_place: @pick_up_place,
          drop_off_place: @drop_off_place,
          pick_up_date_time: @pick_up_date_time,
          drop_off_date_time: @drop_off_date_time,
          driver_age: @driver_age,
          api_key: ENV['SKYSCANNER_API_KEY'],
          user_ip: @user_ip,
          currency: @currency
        ).make_request

      @data = JSON.parse(json)

      if !@data['cars'].nil?
        car_rentals = create_car_rentals(@data['cars'])
      else
        car_rentals = []
      end
      @car_rentals = car_rentals
    end

    private

    def create_car_rentals(rentals)
      car_rentals = []
      rentals.each do |rental|
        car_rental = CarRental.create(rental)
        car_rentals << car_rental
      end

    end

  end

end
