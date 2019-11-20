class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order("role DESC").page(params[:page]).per(10)
  end
end
