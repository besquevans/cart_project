require 'rails_helper'

RSpec.describe User, type: :model do
  it "should count all user" do
    expect(User.get_user_count).to eq(0)
    create(:user)
    expect(User.get_user_count).to eq(1)
  end

  it "should count all order by this user" do 
    user = create(:user)
    product = create(:product)
    cart = create(:cart)
    cart.add_cart_item(product)
    expect(user.get_order_count).to eq(0)
    order = create(:order)
    order.add_order_items(cart)
    order.amount = cart.subtotal
    user.orders << order
    expect(user.get_order_count).to eq(1)
  end
end