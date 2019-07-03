require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Association' do
    it { should have_many(:cart_items) }
    it { should have_many(:carts) }
  end

  describe 'Validation' do
    subject { FactoryBot.create(:product) }
    it { should validate_presence_of(:name) }   #product必須有name
  end
end