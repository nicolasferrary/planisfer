class PaymentsController < ApplicationController
  before_action :set_order

  def new
    @trip = Trip.find(params[:trip_id])
    @default_values = define_default_values(@order, @trip.nb_travelers)
    @status = check_status
  end

  def create
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
    redirect_to order_path(@order)

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

