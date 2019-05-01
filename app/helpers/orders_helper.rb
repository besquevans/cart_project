module OrdersHelper
#訂單未取消顯示取消訂單
  def show_cancer_order(order)
    if order.shipping_status == "not_shipped"
      link_to "Cancell Order", order_path(order), method: :patch, class: "btn btn-default"
    end
  end

#登入的使用者可以查看訂單
  def show_my_orders
    if !!current_user
      link_to "My Orders", orders_path(current_user.orders), class: "btn btn-default"
    end
  end
end
