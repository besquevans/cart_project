module ProductsHelper
#顯示商品照片
  def show_product_picture(product)
    if product.image?
      image_tag product.image.url, class: "img-responsive center-block"
    else
      content_tag(:span, class: "glyphicon glyphicon-picture") 
    end
  end
end
