module CartsHelper
#購物車有東西時可以點擊
  def show_my_cart
    if current_cart.subtotal != 0
      link_to "View Cart", cart_path(current_cart), class: "btn btn-default"
    end
  end
end
