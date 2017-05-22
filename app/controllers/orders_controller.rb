class OrdersController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id])
    @options = params[:options]
    @order  = Order.create!(trip_sku: @trip.sku, amount: @trip.price, state: 'pending')
    redirect_to new_order_payment_path(@order, trip_id: @trip.id)
  end

  def show
    @order = Order.where(state: 'paid').find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @user = @order.user
#TOdo
    # @quote_id = params([:quote_id])
    # #Worldia : validate payment
    # worldia_validate_payment(@quote_id)
  end

  private

  def worldia_validate_payment(quote_id)
    url = "http://www.worldia.com/api/v1/checkout/#{quote_id}/complete"
    RestClient.post url
  end

end
