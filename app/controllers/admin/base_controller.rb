class Admin::BaseController < ApplicationController
  # 這個 Controller 繼承 ApplicationController 所以可以用自己與 Application 的 method
  # 這裡的 namespace controller 在全部繼承這個Base controller 就可以使用這裡的 method了！
  before_action :authenticate_admin

  private

   def authenticate_admin
     unless current_user.admin?
       flash[:alert] = "Not allow!"
       redirect_to root_path
     end
   end
end