class ProductsController < ApplicationController
  
  def index
    @products = Product.page(params[:page]).per(10)
  end

  
end
