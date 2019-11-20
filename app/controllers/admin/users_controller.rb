class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]
  
  def index
    @users = User.order("role DESC").page(params[:page]).per(10)
  end

  def edit
  end

  def update
    if @user.admin_enough?
      if @user.update(user_params)
        flash[:notice] = "user was successfully updated"
        redirect_to admin_users_path()
      else
        flash.now[:alert] = "user was failed to update"
        render :edit
      end
    else
      flash.now[:alert] = "admin not enough"
      render :edit
    end
  end

  def destroy
    if @user.admin_enough?
      @user.destroy
      redirect_to admin_users_path
      flash[:alert] = "user was deleted"
    else
      redirect_to admin_users_path
      flash[:alert] = "admin not enough"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar, :name, :email, :role)
  end
end
