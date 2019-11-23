class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:edit, :update, :destroy]
  
  @@reverse = false
  def index
    if params[:order]
      if @@reverse == true
        @t = Product.order("#{params[:order]}" + " DESC")
        @@reverse = false
      else
        @t = Product.order(params[:order])
        @@reverse = true
      end
      @products = @t.page(params[:page]).per(10)
    else
      @products = Product.page(params[:page]).per(10)
    end
    
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

  def destroy
    @product.destroy
    redirect_to admin_products_path
    flash[:alert] = "product was deleted"
  end

  private

  def product_params
    params.require(:product).permit(:name, :image, :description, :price)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
