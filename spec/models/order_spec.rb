require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "Association" do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
    it { should have_many(:products) }
    it { should have_many(:payments) }
  end

  describe "vaildation" do #必填選項
    it { should validate_presence_of(:name) }   
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone) }
  end

  describe "status default" do
    it "shipping status should be not shipped" do
      order = create(:order)
      expect(order.shipping_status).to eq("not_shipped")
    end

    it "payment status should be not paid" do
      order = create(:order)
      expect(order.payment_status).to eq("not_paid")
    end
  end

  
  describe "add product to order" do
    it "when create order" do
      order = create(:order)
      expect(order.order_items.size).to eq(0)
    end

    it "when add items to order" do
      product = create(:product)
      cart = create(:cart)
      cart.add_cart_item(product)
      order = create(:order)
      order.add_order_items(cart)
      expect(order.order_items.size).to eq(1)
    end
  end

  describe "subtotal" do
    it "when subtotal = 2 + 7" do
      product1 = create(:product, price: 2)
      product2 = create(:product, price: 7)
      cart = create(:cart)
      cart.add_cart_item(product1)
      cart.add_cart_item(product2)
      order = create(:order)
      order.add_order_items(cart)
      expect(order.subtotal).to eq(9)
    end
  end
end