class ApiController < ActionController::Base
  protect_from_forgery with: :null_session   
  #拿掉CSRF功能
  before_action :authenticate_user_from_token!

  def authenticate_user_from_token!
    if params[:auth_token].present?
      user = User.find_by_authentication_token(params[:auth_token])
      # sign_in 是 Devise 的方法
      sign_in(user, store: false) if user
    end
  end
end
