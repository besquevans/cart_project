require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Association' do
    it { should have_many(:orders) }
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

  describe 'admin enough?' do
    it 'when 1 user' do
      user = create(:user)
      expect(user.admin_enough?).to eq(true)
    end

    it 'when 1 user 1 admin' do
      user = create(:user)
      admin = create(:user, :role => "admin")
      expect(user.admin_enough?).to eq(true)
      expect(admin.admin_enough?).to eq(false)
    end

    it 'when 2 admin' do
      create(:user, :role => "admin")
      admin = create(:user, :role => "admin")
      expect(admin.admin_enough?).to eq(true)
    end
  end

  describe 'count' do
    it 'should get_user_count' do
      10.times do 
        create(:user)
      end
      expect(User.get_user_count).to eq(10)
    end
  end
end