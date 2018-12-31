class OrderItem < ApplicationRecord
  belongs_to :order 
  belongs_to :product


  def item_total
    self.quantity * self.product.price
  end
end
