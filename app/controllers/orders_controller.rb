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
# Uncomment for worldia
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
    @member = @order.member
    @quote_id = params[:quote_id]

    @region = @trip.search.region

    # # Worldia : validate payment
    # worldia_validate_payment(@quote_id)

    @trip_airports = define_trip_airports(@trip)
    @pois = define_pois(@region)
    @initial_markers = build_markers(@pois, @trip_airports)
  end

  def update
    @order = Order.find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @passengers = {}
    @nb_travelers = @trip.nb_adults + @trip.nb_children + @trip.nb_infants
      for num in (1..@nb_travelers)
        @passengers["#{num}"] = {
          title: params[:title_pax]["#{num}"],
          first_name: params[:first_name_pax]["#{num}"],
          name: params[:name_pax]["#{num}"]
        }
      end
    @order.passengers = @passengers
    @order.mail = params[:email]
    @order.save
    @order.member = current_member
    @order.save

    # # Worldia : Add customer to quote
    # @quote_id = params[:quote_id]
    # worldia_add_customer_to_quote(@member, @quote_id)
    # #Worldia : Add passengers to quote
    # worldia_add_passengers_to_quote(@passengers, @quote_id, @nb_travelers)
    # #Worldia : Create payment
    # worldia_create_payment(@quote_id)

     @options = {
      :pick_up_location => params[:pick_up_location],
      :drop_off_location => params[:drop_off_location],
      :pick_up_date_time => params[:pick_up_date_time],
      :drop_off_date_time => params[:drop_off_date_time],
    }

    redirect_to new_order_payment_path(@order, trip_id: @trip.id, status: "OK", options: @options, quote_id: @quote_id)
  end


  def add_question_to_order
    @order = Order.find(params[:order_id])
    @trip = Trip.find(params[:trip_id])
    @order.question = params[:question]
    @order.save
    redirect_to order_path(@order, trip_id: @trip.id)
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

  def worldia_add_customer_to_quote(member, quote_id)
    url = "https://www.worldia.com/api/v1/carts/#{quote_id}"
    json = {
    "customerId": member.id
    }.to_json
    RestClient.patch(url, json, {:content_type => 'application/json'})
  end

  def worldia_add_passengers_to_quote(passengers, quote_id, nb_travelers)
    url = "https://www.worldia.com/api/v1/checkout/#{quote_id}/select_pax"

    request_hash = {
      "comments": [{"comment":"No comment"}],
      "pax":[]
    }
    for num in (1..nb_travelers)
      passenger_hash = {
        "dateOfBirth": "1900-01-01",
        "title": passengers["#{num}"][:title],
        "firstName": passengers["#{num}"][:first_name],
        "lastName": passengers["#{num}"][:name]
        }
        request_hash[:pax] << passenger_hash
    end

    json = request_hash.to_json
    RestClient.put url, json, {:content_type => 'application/json'}
  end

  def worldia_create_payment(quote_id)
    url = "https://www.worldia.com/api/v1/checkout/#{quote_id}/select_options"
    json = {
      "insuranceMethod": "NO_INSURANCE",
      "paymentMethod":"phone"
      }.to_json
    RestClient.put(url, json, {:content_type => 'application/json'})
  end

  def worldia_validate_payment(quote_id)
    url = "https://www.worldia.com/api/v1/checkout/#{quote_id}/complete"
    json = {}.to_json
    response = RestClient.post url, json, {:content_type => 'application/json'}
    raise
  end

  def define_pois(region)
    @pois = []
    @region.pois.each do |poi_name|
      poi = Poi.find_by_name(poi_name.strip)
      @pois << poi
    end
    @pois
  end

  def define_trip_airports(trip)
    arrival_iata = trip.round_trip_flight.flight1_destination_airport_iata
    return_iata = trip.round_trip_flight.flight2_origin_airport_iata
    arrival_airport = Airport.find_by_iata(arrival_iata)
    return_airport = Airport.find_by_iata(return_iata)
    airports = [arrival_airport, return_airport]
  end

  def build_markers(pois, airports)
    pois_markers = Gmaps4rails.build_markers(pois) do |poi, marker|
      @poi = poi
      marker.lat poi.latitude
      marker.lng poi.longitude
      marker.title poi.name

      marker.infowindow render_to_string(:partial => "/shared/poi_infowindow", :locals => { :object => poi})
      # marker.json { :id => poi.id }
      marker.picture({
                  :url => view_context.image_url("heart-only.png"),
                  :width   => 20,
                  :height  => 16,
                 })
    end
    airports_markers = Gmaps4rails.build_markers(airports) do |airport, marker|
      marker.lat airport.coordinates.gsub(/\:(.*)/, '').to_f
      marker.lng airport.coordinates.gsub(/(.*)\:/, '').to_f
      marker.infowindow airport.cityname + " airport"
      marker.title ""
      marker.picture({
        :url => view_context.image_url("airport-black.svg"),
        :width   => 70,
        :height  => 35,
      })
    end
    markers = pois_markers + airports_markers
  end

end
