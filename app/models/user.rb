class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :orders, dependent: :destroy

  scope :admin, -> { where("role = ?", 'admin') }

  before_create :generate_authentication_token
  #before_destroy :ckeck_admin_enough
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

  def self.get_facebook_user_data(access_token)
    # 需要傳入你的臉書登入權杖
    # 使用權杖向 Facebook 發送 Request，請求回傳使用者的臉書資料
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.avatar = auth.info.image # assuming the user model has an image
    end
  end

  def ckeck_admin_enough
    unless admin_enough?
      errors[:base] << "admin not enough!!!"
      throw :abort      #中斷回呼
    end
  end

  def admin_enough?
    User.admin.size > 1 || admin? == false
  end

end
