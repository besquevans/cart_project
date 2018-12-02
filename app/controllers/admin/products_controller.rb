class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_product, only: [:edit, :update, :destroy]
  
  def index
    @products = Product.all
  end

  def new 
    @product = Product.new
  end

  def create
    @product = Restaurant.new(product_params)
    if @product.save
      flash[:notice] = "product was successfully created"
      redirect_to admin_restaurants_path
    else
      flash.now[:alert] = "product was failed to create"
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "product was successfully updated"
      redirect_to admin_products_path(@product)
    else
      flash.now[:alert] = "product was failed to update"
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_rproducts_path
    flash[:alert] = "product was deleted"
  end

  private

  def product_params
    params.require(:product).permit(:name, :image, :description, :price)
  end

  def set_product
    @product = @product.find(params[:id])
  end
end
