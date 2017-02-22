class RoundTripFlightController < ApplicationController
  def create
    # @currency = nil # TODO : Check if we need to specify it
    @currency = extract_currency(option)
    @price = extract_total_price(option)




    @destination_city = extract_destination_city(option)
    @destination_airport = extract_destination_airport(option)
    @origin_airport = extract_origin_airport(option)
    @departure_time_there = extract_departure_time(option, 0)
    @arrival_time_there = extract_arrival_time(option, 0)
    @departure_time_back = extract_departure_time(option, 1)
    @arrival_time_back = extract_arrival_time(option, 1)
    @carrier = extract_carrier(option)
    @flight_number_there = @carrier + extract_flight_number(option, 0)
    @flight_number_back = @carrier + extract_flight_number(option, 1)
    @trip_id = extract_trip_id(option)

     validates :price, presence: true
 validates :flight1_origin_airport_iata, presence: true
 validates :flight1_destination_airport_iata, presence: true
 validates :flight2_origin_airport_iata, presence: true
 validates :flight2_destination_airport_iata, presence: true
 validates :flight1_take_off_at, presence: true
 validates :flight1_landing_at, presence: true
 validates :flight2_take_off_at, presence: true
 validates :flight2_landing_at, presence: true


  end

  def destroy
  end


  private

  def extract_currency(item)
    @currency = item['saleTotal'].match(/\w{3}/).to_s
  end

  def extract_total_price(item)
      item['saleTotal'].match(/\d+\.*\d+/)[0].to_f
    end
  end

end
