require 'rest-client'
# require 'json'

class PaymentsController < ApplicationController
  before_action :set_order

  def new
    @trip = Trip.find(params[:trip_id])

    @pick_up_location = params[:options][:pick_up_location]
    @drop_off_location = params[:options][:drop_off_location]
    @pick_up_date_time = params[:options][:pick_up_date_time]
    @drop_off_date_time = params[:options][:drop_off_date_time]

    @nb_travelers = @trip.nb_adults.to_i + @trip.nb_children.to_i + @trip.nb_infants.to_i
    @default_values = define_default_values(@order, @nb_travelers)
    @status = check_status
    # Create a component for worldia
    @component = worldia_create_component(@trip)
    # Gather the component's variation
    @code = @component["code"]
    component_variation = worldia_gather_variation(@code, @trip)
    # Create a quote
    quote = worldia_create_quote(@trip)
    # #Add component to quote
    @variation_id = component_variation["id"]
    @quote_id = quote["id"]
    quote_with_comp = worldia_add_component_to_quote(@quote_id, @variation_id)
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @quote_id = params[:quote_id]
    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @order.amount_cents, # or amount_pennies
      description:  "Payment for trip #{@order.trip_sku} for order #{@order.id}",
      currency:     @order.amount.currency
    )

    @order.update(payment: charge.to_json, state: 'paid')
    redirect_to order_path(@order, trip_id: @trip.id, quote_id: @quote_id)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_order_payment_path(@order)
  end

  private

  def set_order
    @order = Order.where(state: 'pending').find(params[:order_id])
  end

  def define_default_values(order, nb)
    default_values ={}
    if !order.user.nil?
      default_values[:email] = order.user.mail
    else
      default_values[:email] = nil
    end
    for num in (1..nb)
      default_values["#{num}"] = {}
      if !order.user.nil?
        default_values["#{num}"][:title] = order.user.passengers["#{num}"][:title]
        default_values["#{num}"][:first_name] = order.user.passengers["#{num}"][:first_name]
        default_values["#{num}"][:name] = order.user.passengers["#{num}"][:name]
      else
        default_values["#{num}"][:title] = nil
        default_values["#{num}"][:first_name] = nil
        default_values["#{num}"][:name] = nil
      end
    end
    default_values
  end

  def check_status
    if params[:status] == "OK"
      @status = "OK"
    else
      @status = "none"
    end
  end

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
      "Flight1: #{trip.round_trip_flight.f1_number} on #{trip.starts_on} ; Flight2: #{trip.round_trip_flight.f2_number} on #{trip.returns_on} ; car rental: #{trip.car_rental.car.category} car with #{trip.car_rental.company} between #{trip.car_rental.pick_up_date_time} and #{trip.car_rental.drop_off_date_time}. Pick up location : #{trip.car_rental.pick_up_location} and drop_off location : #{trip.car_rental.drop_off_location}"
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



end

