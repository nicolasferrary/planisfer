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
    # Worldia : Add user to quote
    @quote_id = params[:quote_id]
    worldia_add_user_to_quote(@user, @quote_id)

    #Worldia : Add passengers to quote
    worldia_add_passengers_to_quote(@passengers, @quote_id, @nb_travelers)
#TODO
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
    url = "https://www.worldia.com/api/v1/carts/#{quote_id}"
    json = {
    "customerId": user.id
    }.to_json
    response = RestClient.patch(url, json, {:content_type => 'application/json'})
  end

  def worldia_add_passengers_to_quote(passengers, quote_id, nb_travelers)
    url = "https://www.worldia.com/api/v1/checkout/#{quote_id}/select_pax"
    # json = {
    #   "comments": [{"comment":""}],
    #   "pax": [{
    #     "dateOfBirth": "1972-04-24",
    #     "title": "Mr",
    #     "firstName": "John",
    #     "lastName": "Smith"
    #     },{
    #     "dateOfBirth": "1972-04-24",
    #     "title": "Mr",
    #     "firstName": "John",
    #     "lastName": "Smith"
    #     }]
    #   }.to_json

    request_hash = {
      "comments": [{"comment":"No comment"}],
      "pax":[]
    }
    for num in (1..nb_travelers)
      passenger_hash = {
        "dateOfBirth": "1900-01-01",
        "title": passengers["#{num}"][:title],
        "firstName": passengers["#{num}"][:title],
        "lastName": passengers["#{num}"][:name]
        }
        request_hash[:pax] << passenger_hash
    end

    json = request_hash.to_json
    response = RestClient.put url, json, {:content_type => 'application/json'}
  end

  # def worldia_pax_hash(passengers)
  #   pax_hash = {}
  #   pax_hash["comments"] = [{"comment" => ""}]
  #   pax_hash["pax"] = []
  #   for num in (1..@trip.nb_travelers)
  #     pass_hash = {}
  #     pass_hash["dateOfBirth"] = ""
  #     pass_hash["title"] = passengers["#{num}"][:title]
  #     pass_hash["firstName"] = passengers["#{num}"][:title]
  #     pass_hash["lastName"] = passengers["#{num}"][:name]
  #     pax_hash["pax"] << pass_hash
  #   end
  #   pax_hash
  # end

  def worldia_create_payment(quote_id)
    url = "https://www.worldia.com/api/v1/checkout/#{quote_id}/select_options"
    json = {
      "insuranceMethod": "NO_INSURANCE",
      "paymentMethod":"phone"
      }.to_json
    response = RestClient.put(url, json, {:content_type => 'application/json'})
  end

end
