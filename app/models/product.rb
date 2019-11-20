class Product < ApplicationRecord
  validates_presence_of :name, :price #必填
  validates :name, uniqueness: true
  validates_numericality_of :price, greater_than_or_equal_to: 1
  mount_uploader :image, PhotoUploader #圖片上傳器

  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
end
