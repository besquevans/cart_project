require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Association' do
    it { should have_many(:cart_items) }
    it { should have_many(:carts) }
  end

  describe 'Validation' do
    it 'is not valid without name' do #product必須有name
      product = Product.new(:name => "")
      expect(product).to_not be_valid
    end
  end
end