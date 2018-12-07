class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :current_cart

  private

  def current_cart
    @cart || set_cart #return @cart if @cart exist, or call set_cart
  end

  def set_cart
    if session[:cart_id]
      @cart = Cart.find_by(id: session[:cart_id])
    end

    @cart ||= Cart.create

    session[:cart_id] = @cart.id
    @cart
  end
end
