class Api::V1::ProductsController < ApiController
  def index 
    @products = Product.find_each
    render json: {
      data: @products.map do |product|
        {
          name: product.name,
          description: product.description,
          price: product.price,
          image: product.image
        }
      end
    }
  end

  def show
    @product = Product.find_by(id: params[:id])
    if !@product
      render json: {
        message: "Can't find the product!",
        status: 400
      }
    else
      render json: {
        name: @product.name,
        description: @product.description,
        price: @product.price,
        image: @product.image
      }
    end
  end
end
