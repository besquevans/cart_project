class Api::V1::AuthController < ApiController

  before_action :authenticate_user!, only: :logout

  # POST /api/v1/signup
  def signup
    user = User.new(email: params[:email], password: params[:password])

    if user.save
      render json: {
        message: "sign up success",
        user_id: user.id}
    else
      render json: {message: "failed", error: user.errors}, status: 400
    end
  end

  # POST /api/v1/login
  def login
    success = false

    if params[:email] && params[:password]
      user = User.find_by_email(params[:email])
      success = user && user.valid_password?(params[:password])
    elsif params[:access_token]
      fb_data = User.get_facebook_user_data(params[:access_token])
      if fb_data
        auth_hash = OmniAuth::AuthHash.new({
          uid: fb_data["id"],
          info: {
              email: fb_data["email"]
          },
          credentials: {
              token: params[:access_token],
              expires_at: Time.now + 60.days
          }
        })
        user = User.from_omniauth(auth_hash)
      end
      success = fb_data && user.persisted?
    end

    if success
      render json: {
        message: "ok",
        auth_token: user.authentication_token
      }
    else
      render json: { message:  "Email or Password is wrong" }, status:  401
    end
  end

  # POST /api/v1/logout
  def logout
    # 登出時刷新 token，做為下次登入時比對用，而舊的 token 就失效了
    current_user.generate_authentication_token
    current_user.save!

    render json: { message:  "User logout" }
  end
end
