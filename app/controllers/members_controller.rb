class membersController < ApplicationController

   def update
    @order = Order.find(params[:order_id])
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
    @member.passengers = @passengers
    @member.mail = params[:email]
    @member.save
    @order.member = current_member
    @order.save

# UNCOMMENT TO LAUNCH WORLDIA CALLS
    # # Worldia : Add user to quote
    # @quote_id = params[:quote_id]
    # worldia_add_user_to_quote(@member, @quote_id)
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

end
