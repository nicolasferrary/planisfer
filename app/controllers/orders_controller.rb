class OrdersController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id])
    @options = params[:options]
    @order  = Order.create!(trip_sku: @trip.sku, amount: @trip.price, state: 'pending')
    @options = {
      :trip_id => @trip.id,
      :pick_up_location => params[:pick_up_location],
      :drop_off_location => params[:drop_off_location],
      :pick_up_date_time => params[:pick_up_date_time],
      :drop_off_date_time => params[:drop_off_date_time],
    }

# UNCOMMENT TO LAUNCH WORLDIA CALLS

    # # Create a component for worldia
    # @component = worldia_create_component(@trip)
    # # Gather the component's variation
    # @code = @component["code"]
    # component_variation = worldia_gather_variation(@code, @trip)
    # # Create a quote
    # quote = worldia_create_quote(@trip)
    # # Add component to quote
    # @variation_id = component_variation["id"]
    # @quote_id = quote["id"]
    # quote_with_comp = worldia_add_component_to_quote(@quote_id, @variation_id)

    redirect_to new_order_payment_path(@order, trip_id: @trip.id, options: @options, quote_id: @quote_id)
  end

  def show
    @order = Order.where(state: 'paid').find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @user = @order.user
#TOdo
    @quote_id = params[:quote_id]

# UNCOMMENT TO LAUNCH WORLDIA CALLS
    # # Worldia : validate payment
    # worldia_validate_payment(@quote_id)
  end

  private

  def worldia_create_component(trip)
    request_hash = {
      "name": trip.sku,
      "status":3,
      "type":"activity",
      "pricingCalculator":"standard_fixed",
      "pricingConfiguration":{"cost": trip.price_cents.fdiv(100), "price": trip.price_cents.fdiv(100), "purchasingCurrency": "EUR"},
      "shortDescription":define_description(trip),
      "location":300
      }
    json = request_hash.to_json
    url = "https://www.worldia.com/api/v1/products/"
    response = RestClient.post url, json, {:content_type => 'application/json'}
    hash_response = JSON.parse(response.body)
  end

  def define_description(trip)
    if !trip.car_rental.nil?
      "Flight1: #{trip.round_trip_flight.f1_number} on #{trip.starts_on} ; Flight2: #{trip.round_trip_flight.f2_number} on #{trip.returns_on} ; car rental: #{trip.car_rental.category} car with #{trip.car_rental.company} between #{trip.car_rental.pick_up_date_time} and #{trip.car_rental.drop_off_date_time}. Pick up location : #{trip.car_rental.pick_up_location} and drop_off location : #{trip.car_rental.drop_off_location}"
    else
      "Flight1: #{trip.round_trip_flight.f1_number} on #{trip.starts_on} ; Flight2: #{trip.round_trip_flight.f2_number} on #{trip.returns_on} ; No car rental"
    end
  end

  def worldia_gather_variation(code, trip)
    date = trip.starts_on.strftime("%Y-%m-%d")
    url = "https://www.worldia.com/api/v1/product-variants/resolve?date=2017-09-01&options=&paxPlan=45,45&product=#{code}"
    response = RestClient.get(url, content_type: :json, accept: :json)
    hash_response = JSON.parse(response.body)
  end

  def worldia_create_quote(trip)
    request_hash = {
      "name":trip.sku,
      "paxPlan":[[{
        "dateOfBirth": "1972-04-24",
        "age": 44
        },]],
      "startDate":trip.starts_on.strftime("%Y-%m-%d"),
      "areas": [{"id": 41}]
      }
      json = request_hash.to_json
    url = "https://www.worldia.com/api/v1/carts/"
    response = RestClient.post url, json, {:content_type => 'application/json', accept: :json}
    hash_response = JSON.parse(response.body)
  end

  def worldia_add_component_to_quote(quote_id, variation_id)
    request_hash =  {
    "day": 0,
    "position": 0,
    "variantId": variation_id
    }
    json = request_hash.to_json
    url = "https://www.worldia.com/api/v1/carts/#{quote_id}/items/"
    response = RestClient.post url, json, {:content_type => 'application/json'}
    hash_response = JSON.parse(response.body)
  end

  def worldia_validate_payment(quote_id)
    url = "https://www.worldia.com/api/v1/checkout/#{quote_id}/complete"
    json = {}.to_json
    response = RestClient.post url, json, {:content_type => 'application/json'}
  end

end
