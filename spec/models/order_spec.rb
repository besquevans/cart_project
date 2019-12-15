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
  
  describe "add product to order" do
    it "when add items to order" do
      product = create(:product)
      cart = create(:cart)
      cart.add_cart_item(product)
      order = Order.new
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
      order = Order.new
      order.add_order_items(cart)
      expect(order.subtotal).to eq(9)
    end
  end

  describe "count_sold" do
    it "when 1 prudct sold and paid" do
      product = create(:product)
      cart = create(:cart)
      cart.add_cart_item(product)
      order = Order.new
      order.add_order_items(cart)
      order.payment_status = "paid"
      order.save
      order.count_sold
      expect(Product.find(product.id).sold_count).to eq(1)
    end

    it "when 1 prudct sold 2 and paid" do
      product = create(:product)
      cart = create(:cart)
      cart.add_cart_item(product)
      cart.add_cart_item(product)
      order = Order.new
      order.add_order_items(cart)
      order.payment_status = "paid"
      order.save
      order.count_sold
      expect(Product.find(product.id).sold_count).to eq(2)
    end

    it "when 2 prudct sold 2/3 and paid" do
      product1 = create(:product)
      product2 = create(:product)
      cart1 = create(:cart)
      cart2 = create(:cart)

      cart1.add_cart_item(product1)
      cart1.add_cart_item(product2)
      cart2.add_cart_item(product1)
      cart2.add_cart_item(product2)
      cart2.add_cart_item(product2)

      order1 = Order.new
      order1.add_order_items(cart1)
      order2 = Order.new
      order2.add_order_items(cart2)

      order1.payment_status = "paid"
      order1.save
      order1.count_sold
      order2.payment_status = "paid"
      order2.save
      order2.count_sold

      expect(Product.find(product1.id).sold_count).to eq(2)
      expect(Product.find(product2.id).sold_count).to eq(3)
    end
  end
end