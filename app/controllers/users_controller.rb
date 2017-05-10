class UsersController < ApplicationController

  def create
    @order = Order.find(params[:order_id])
    @trip = Trip.find(params[:trip_id])
    user = User.new()
    passengers = {}
      for num in (1..@trip.nb_travelers)
        passengers["#{num}"] = {
          title: params[:title_pax]["#{num}"],
          first_name: params[:first_name_pax]["#{num}"],
          name: params[:name_pax]["#{num}"]
        }
      end
    user.passengers = passengers
    user.mail = params[:email]
    user.save
    @order.user = user
    @order.save
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


end
