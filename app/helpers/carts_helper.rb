module CartsHelper
#購物車有東西
  def cart_has_things?
    current_cart.subtotal != 0
  end

#購物車內商品數為１
  def item_only_one?(item)
    item.quantity == 1
  end

#購物車內無商品
  def nothing_in_cart?
    current_cart.cart_items.size == 0
  end

end



