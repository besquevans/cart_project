class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :payments

  #必填
  validates_presence_of :name, :address, :phone
  validates_numericality_of :amount, greater_than: 0
  validates :phone, length: { in: 8..14 }
  validates :payment_status, inclusion: { in: %w(not_paid paid), message: "%{value} is not a valid PAYMENT_STATUS" }
  validates :shipping_status, inclusion: { in: %w(not_shipped shipped cancelled), message: "%{value} is not a valid SHIPPING_STATUS" }

  # set constant to generate select options
  PAYMENT_STATUS = [
    ["Not Paid", :not_paid],
    ["Paid", :paid]
  ]

  SHIPPING_STATUS = [
    ["Not Shipped", :not_shipped],
    ["Shipped",:shipped]
  ]
  
  def add_order_items(cart)
    cart.cart_items.each do |item|
      self.order_items.build(
        product_id: item.product.id,
        quantity: item.quantity,
        price: item.product.price
        )
    end
  end

  def subtotal
    order_items.map{ |x| x.item_total }.sum
  end

  def count_sold
    if payment_status == "paid"
      order_items.each do |item|
        product = Product.find(item.product_id)
        product.sold_count += item.quantity
        product.save
      end
    end
  end
end
