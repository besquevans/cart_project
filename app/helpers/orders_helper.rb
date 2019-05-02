module OrdersHelper
  def can_pay?(order)
    order.payment_status == "not_paid" && order.shipping_status != "cancelled"
  end

#訂單未付款
  def not_shipped?(order)
    order.shipping_status == "not_shipped"
  end

end
