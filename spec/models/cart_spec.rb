require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "Association" do
    it { should have_many(:cart_items) }
  end

  describe "add product to cart" do
    it "when add 1 product to cart" do
      product = create(:product)
      cart = create(:cart)
      cart.add_cart_item(product)
      expect(cart.cart_items.size).to eq(1)
    end
  end

  describe "subtotal" do
    it "when subtotal = 5 + 2" do
      product1 = create(:product, price: 5)
      product2 = create(:product, price: 2)
      cart = create(:cart)
      cart.add_cart_item(product1)
      expect(cart.subtotal).to eq(5)
      cart.add_cart_item(product2)
      expect(cart.subtotal).to eq(7)
    end
  end

  describe "find_item_by" do
    it "when product in cart" do
      product = create(:product)
      cart = create(:cart)
      cart.add_cart_item(product)
      product_id = cart.find_item_by(product).product_id
      expect(product_id).to eq(product.id)
    end
  end
end