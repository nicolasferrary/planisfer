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

    @options = {
      :trip_id => @trip.id,
      :pick_up_location => @pick_up_location,
      :drop_off_location => @drop_off_location,
      :pick_up_date_time => @pick_up_date_time,
      :drop_off_date_time => @drop_off_date_time,
    }

    @quote_id = params[:quote_id]
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

end

