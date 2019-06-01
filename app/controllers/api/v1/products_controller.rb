class Api::V1::ProductsController < ApiController
  before_action :authenticate_user!, except: :index
  def index 
    @products = Product.find_each
  end

  def show
    @product = Product.find_by(id: params[:id])
    if !@product
      render json: {
        message: "Can't find the product!",
        status: 400
      }
    else
      render "api/v1/products/show"
    end
  end
end
