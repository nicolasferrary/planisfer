require 'rest-client'

class UsersController < ApplicationController

  def create
    @order = Order.find(params[:order_id])
    @trip = Trip.find(params[:trip_id])
    @user = User.new()
    @passengers = {}
      for num in (1..@trip.nb_travelers)
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

    # Worldia : Add user to quote
    @quote_id = params([:quote_id])
    worldia_add_user_to_quote(@user, @quote_id)

    #Worldia : Add passengers to quote
    worldia_add_passengers_to_quote(@passengers, @quote_id)

    #Worldia : Create payment
    worldia_create_payment(@quote_id)

    redirect_to new_order_payment_path(@order, trip_id: @trip.id, status: "OK")
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
    url = "http://www.worldia.com/api/v1/carts/#{quote_id}"
    jon = {
    "customerId": user.id
    }.to_json
    RestClient.patch(url, json, {:content_type => 'application/json'})
  end

  def worldia_add_passengers_to_quote(passengers, quote_id)
    url = "http://www.worldia.com/api/v1/checkout/#{quote_id}/select_pax"
    json = worldia_pax_hash(passengers).to_json
    RestClient.post url, json, {:content_type => 'application/json'}

  end

  def worldia_pax_hash(passengers)
    pax_hash = {}
    pax_hash[:pax] = []
    for num in (1..@trip.nb_travelers)
      pass_hash = {}
      pass_hash[:title] = passengers["#{num}"][:title]
      pass_hash[:firstName] = passengers["#{num}"][:first_name]
      pass_hash[:lastName] = passengers["#{num}"][:name]
      pax_hash[:pax] << pass_hash
    end
    pax_hash
  end

  def worldia_create_payment(quote_id)
    url = "http://www.worldia.com/api/v1/checkout/#{quote_id}/select_options"
    json = {
      "insuranceMethod": "NO_INSURANCE",
      "paymentMethod":"phone"
      }.to_json
    RestClient.put(url, json, {:content_type => 'application/json'})
  end

end
