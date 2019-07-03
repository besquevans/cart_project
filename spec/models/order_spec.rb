require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
    it { should have_many(:products) }
    it { should have_many(:payments) }
  end

  describe 'Validation' do
    
    it { should validate_presence_of(:name) }   #product必須有name
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:phone) }
    it "order amount more than 0" do
      product = create(:product)
      cart = create(:cart)
      cart.add_cart_item(product)
      order = FactoryBot.create(:order) 
      order.amount = cart.subtotal
      expect(order.amount).to be > 0
    end
  end
end