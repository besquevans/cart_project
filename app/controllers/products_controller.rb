class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart, :remove_from_cart, :adjust_item]
  
  def index
    @products = Product.page(params[:page]).per(12)
    @items = current_cart.cart_items
  end

  def show
    @items = current_cart.cart_items
  end

  def add_to_cart   
    current_cart.add_cart_item(@product)

    #redirect_back(fallback_location: root_path)
  end

  def remove_from_cart
    cart_item = current_cart.cart_items.find_by(product_id: @product)
    cart_item.destroy
    redirect_back(fallback_location: root_path)
  end

  def adjust_item
    cart_item = current_cart.cart_items.find_by(product_id: @product)
    if params[:type] == "add"
      cart_item.quantity += 1
    elsif params[:type] == "substract"
      cart_item.quantity -= 1
    end

    if cart_item.quantity == 0
      cart_item.destroy
    else
      cart_item.save
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
