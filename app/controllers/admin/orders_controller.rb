class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.page(params[:page]).per(10)
  end

  def edit
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      flash[:notice] = "order was successfully updated"
      if @order.shipping_status == "shipped"
        UserMailer.notify_order_shipped(@order).deliver_now
      end
      if @order.payment_status == "paid"
        UserMailer.notify_order_paid(@order).deliver_now
      end
      redirect_to admin_orders_path(@order)
    else
      flash.now[:alert] = @order.errors.full_messages.to_sentence
      render "admin/orders/edit"
    end
  end


  private

  def order_params
    params.require(:order).permit(:shipping_status, :payment_status)
  end
end
