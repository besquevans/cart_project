require 'spec_helper'

feature "User signs in" do

  scenario "with valid email and password" do
    alice = create(:user)                     # 宣告使用者
    visit user_session_path                           # 訪問登入網頁
    fill_in 'Email', :with => alice.email        # 填寫 Email
    fill_in 'Password', :with => alice.password  # 填寫 Password
    click_button 'Log in'                       # 按下 Sign in 按鈕
    expect(User.count).to eq(1) # you can test model
    expect(page).to have_content 'Signed in successfully.'
  end

end