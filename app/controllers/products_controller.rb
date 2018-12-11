class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart, :remove_from_cart, :adjust_item]
  
  def index
    @products = Product.page(params[:page]).per(10)
  end

  def show

  end

  def add_to_cart   
    current_cart.add_cart_item(@product)

    redirect_back(fallback_location: root_path)
  end

  def remove_from_cart
    cart_item = current_cart.cart_items.find_by(product_id: @product)
    cart_item.destroy
    redirect_back(fallback_location: root_path)
  end

  def adjust_item
    cart_item = current_cart.cart_items.find_by(product_id: @product)

    
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
