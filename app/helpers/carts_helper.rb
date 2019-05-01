module CartsHelper
#購物車有東西時可以點擊
  def show_my_cart(label)
    if current_cart.subtotal != 0
      link_to label, cart_path(current_cart), class: "btn btn-default"
    end
  end
end
