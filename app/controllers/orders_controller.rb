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
    redirect_to new_order_payment_path(@order, trip_id: @trip.id, options: @options)
  end

  def show
    @order = Order.where(state: 'paid').find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @user = @order.user
#TOdo
    @quote_id = params[:quote_id]
    #Worldia : validate payment
    worldia_validate_payment(@quote_id)
  end

  private

  def worldia_validate_payment(quote_id)
    url = "https://www.worldia.com/api/v1/checkout/#{quote_id}/complete"
    json = {}.to_json
    response = RestClient.post url, json, {:content_type => 'application/json'}
  end

end
