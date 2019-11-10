require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Association' do
    it { should have_many(:orders) }
  end

  describe 'add_cart_item' do
    it "should add_cart_item" do 
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

  describe 'authentication_token' do
    it "create user should get authentication_token" do
      user = create(:user)
      expect(user.authentication_token).to_not eq(nil)
    end
  end

  describe 'admin' do
    it 'is admin?' do
      admin = create(:user, :role => "admin")
      expect(admin.admin?).to eq(true)
    end

    it 'is not admin?' do
      admin = create(:user, :role => "adman")
      expect(admin.admin?).to eq(false)
    end
  end

  describe 'count' do
    it 'should get_user_count' do
      10.times do 
        create(:user)
      end
      expect(User.get_user_count).to eq(10)
    end

    it 'should get_order_count' do
      user = create(:user)
      10.times do 
        create(:order, user: user)
      end
      expect(user.get_order_count).to eq(10)
    end
  end
end