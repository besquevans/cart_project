class Product < ApplicationRecord
  validates_presence_of :name #必填
  mount_uploader :image, PhotoUploader #圖片上傳器

  has_many :cartltems
  has_many :carts, through: :cartltems
end
