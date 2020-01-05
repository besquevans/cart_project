class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback_for(:facebook)
  end

  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "#{provider}") if is_navigational_format?
    #缺資料時導回註冊頁面
    else
      session["devise.#{provider}data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path, alert: "無法獲得驗證！"
  end
end