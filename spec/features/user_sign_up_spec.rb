require 'spec_helper'

feature "User sign up" do

  scenario "signing in with correct credentials" do
    visit new_user_registration_path
    
    fill_in 'Email', :with => 'usertest@example.com'
    fill_in 'Password', :with => 'caplin'
    fill_in 'Password confirmation', :with => 'caplin'
    click_button 'Sign up'
      
    expect(User.count).to eq(1) # you can test model
    expect(page).to have_content 'Welcome! You have signed up successfully.' 
  end

end