class Api::V1::AuthController < ApiController
  before_action :authenticate_user!, only: :logout

  def login
    if params[:email] && params[:password]
      user = User.find_by_email(params[:email])
    end

    if user && user.valid_password?(params[:password])
      render json: {
        message: "OK",
        auth_token: user.authentication_token,
        user_id: user.id
      }
    else
      render json: {message: "Email or Password id wrong"}, status: 401
    end
  end

  def logout
    current_user.generate_authencation_token
    current_user.save!

    render json: {message: "OK"}
  end
end
