class ApplicationController < ActionController::Base 

  helper_method :current_cart #可以直接在 View 呼叫 current_cart 方法

  private

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
