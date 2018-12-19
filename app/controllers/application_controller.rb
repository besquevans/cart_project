class ApplicationController < ActionController::Base 
  protect_from_forgery with: :exception

  helper_method :current_cart #可以直接在 View 呼叫 current_cart 方法

  private

  def authenticate_admin!
    unless current_user.admin?
       flash[:alert] = "Not allow!"
       redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    # devise function for customize your redirect hook
    # if there is new order data in the session, go to form page
    if session[:new_order_data].present?
      @cart = Cart.find(session[:cart_id])
      cart_path(@cart)
    else
      # if there is no form data in session, proceed as normal
      super
    end
  end

  def current_cart
    @cart || set_cart #return @cart if @cart exist, or call set_cart
  end

  def set_cart
    if session[:cart_id]
      @cart = Cart.find_by(id: session[:cart_id])
    end

    @cart ||= Cart.create # @cart nil產生一筆新的 Cart 物件

    session[:cart_id] = @cart.id  #確保 server 和 client 交流的資訊裡，有攜帶最新的 @cart.id
    @cart   #回傳@cart 
  end
end
