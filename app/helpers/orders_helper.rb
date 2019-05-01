module OrdersHelper
  def show_cancer_order(order)
    if order.shipping_status == "not_shipped"
      content_tag(:span, link_to("Cancell Order", order_path(order), method: :patch, class: "btn btn-default"))
    end
  end
end
