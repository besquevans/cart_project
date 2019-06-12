require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  render_views
  
  describe "GET about" do
    it "check we have user count info in view template" do
      # 準備變數
      sign_in(create(:user))
      user_count = rand(20..100)
      allow(User).to receive(:get_user_count).and_return(user_count)
      #預期User會收到get_user_count方法，回傳user_count
      
      # 測試
      get :about
      expect(assigns(:user_count)).to eq(user_count)
      expect(response.body).to have_content("There are totally #{user_count} users in this website.")
    end
  end
end