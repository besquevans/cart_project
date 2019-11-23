class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :orders

  before_create :generate_authentication_token
  before_destroy :ckeck_admin_enough
  before_update :ckeck_admin_enough

  def generate_authentication_token
    self.authentication_token = Devise.friendly_token
  end

  def admin?
    self.role == "admin"
  end

#facebook傳入的登入資料
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.avatar = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  #rspec
  def self.get_user_count
    User.all.size
  end

  def get_order_count
    orders.all.size
  end

  def self.get_facebook_user_data(access_token)
    # 需要傳入你的臉書登入權杖
    # 使用權杖向 Facebook 發送 Request，請求回傳使用者的臉書資料
  end
  
  def self.from_omniauth(auth_hash)
    # Facebook 回傳的資訊，會再以 Hash 的形式傳入此方法做後續處理
    # 由於 Facebook 回傳資訊未必能和你的資料庫相容，要在這個方法裡制定標準
    # 透過你制定的標準，把 Hash 整理成能和 User model 相容的資料
  end

  def ckeck_admin_enough
    unless admin_enough?
      errors[:base] << "admin not enough!!!"
      throw :abort
    end
  end

  def admin_enough?
    User.where("role == 'admin'").size > 1 || User.find_by("role == 'admin'") != self
  end

end
