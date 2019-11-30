class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:edit, :update]
  
  def index
    @q = Product.order("id DESC").ransack(params[:q])
    @products = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def new 
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "product was successfully created"
      redirect_to admin_products_path
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

  private

  def product_params
    params.require(:product).permit(:name, :image, :description, :price, :on_sold)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
