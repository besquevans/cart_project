class OrdersController < ApplicationController

  def index
    @orders = Order.includes(:user, :products).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(3)
  end

  def create
    # manually check if user logged in
    if current_user.nil?
      # store order data in session so we can retrieve it later
      session[:new_order_data] = params[:order]
      # redirect to devise login page
      redirect_to new_user_session_path
    elsif current_cart.subtotal != 0
      @order = current_user.orders.new(order_params)
      @order.sn = Time.now.to_i+current_user.id
      @order.add_order_items(current_cart)
      @order.amount = current_cart.subtotal
      if @order.save
        current_cart.destroy
        session.delete(:new_order_data)
        #UserMailer.notify_order_create(@order).deliver_now!
        redirect_to orders_path, notice: "new order created"
      else
        @items = current_cart.cart_items
        render "carts/show"
      end
    else
      flash[:alert] = "Cart created failed."
      redirect_to root_path
    end
  end

  def update
    @order = current_user.orders.find(params[:id])
    if @order.shipping_status == "not_shipped"
      @order.shipping_status = "cancelled"
      @order.save
      redirect_to orders_path, alert: "order##{@order.sn} cancelled."
    end
  end

  def checkout_spgateway
    @order = current_user.orders.find(params[:id])
    if @order.payment_status != "not_paid"
      flash[:alert] = "Order has been paid."
      redirect_to orders_path
    else
      @payment = Payment.create(
        sn: Time.now.to_i,
        order_id: @order.id,
        payment_method: params[:payment_method],
        amount: @order.amount
        )

      render layout: false
      #將 layouts/application.html.erb 關掉，也就是不需要 Navbar，目的是讓畫面愈快愈好
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :phone, :address, :payment_method)
  end
end
