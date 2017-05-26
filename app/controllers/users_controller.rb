require 'rest-client'

class UsersController < ApplicationController

  def create
    @order = Order.find(params[:order_id])
    @trip = Trip.find(params[:trip_id])
    @user = User.new()
    @passengers = {}
    @nb_travelers = @trip.nb_adults + @trip.nb_children + @trip.nb_infants
      for num in (1..@nb_travelers)
        @passengers["#{num}"] = {
          title: params[:title_pax]["#{num}"],
          first_name: params[:first_name_pax]["#{num}"],
          name: params[:name_pax]["#{num}"]
        }
      end
    @user.passengers = @passengers
    @user.mail = params[:email]
    @user.save
    @order.user = @user
    @order.save

# UNCOMMENT TO LAUNCH WORLDIA CALLS
    # # Worldia : Add user to quote
    # @quote_id = params[:quote_id]
    # worldia_add_user_to_quote(@user, @quote_id)
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
    # Problem here. As I am recreating a new payment, I am launching a new creation request to Worldia
  end

  def update
    @order = Order.find(params[:order_id])
    @trip = Trip.find(params[:trip_id])
    @user = User.find(params[:id])
    @user.phone = params[:phone]
    @user.call_time = params[:contact_time]
    @user.save
    redirect_to order_path(@order, trip_id: @trip.id)
  end


  private

  def worldia_add_user_to_quote(user, quote_id)
    url = "https://www.worldia.com/api/v1/carts/#{quote_id}"
    json = {
    "customerId": user.id
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

end
