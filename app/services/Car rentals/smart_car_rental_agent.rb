module Car_rental

  class SmartCarRentalAgent
    def initialize(args = {})
      @pick_up_place = args[:pick_up_place]
      @drop_off_place = args[:drop_off_place]
      @pick_up_date_time = args[:pick_up_date_time]
      @drop_off_date_time = args [:drop_off_date_time]
      @driver_age = args[:driver_age]
    end

    def obtain_offers
      json = Car_rental::CarRentalRequester.new(
          pick_up_place: @pick_up_place,
          drop_off_place: @drop_off_place,
          pick_up_date_time: @pick_up_date_time,
          drop_off_date_time: @drop_off_date_time,
          driver_age: @driver_age
          api_key: ENV['SKYSCANNER_API_KEY']
        ).make_request

      @data = JSON.parse(json)

      if !@data['trips']['tripOption'].nil?
        rtf = create_rtf(@data['trips']['tripOption'])
      else
        rtf = []
      end
      @rtf = rtf
    end

    private

    def create_car_rental
    end

  end


end
