class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

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

#facebook or google傳入的登入資料
  def self.from_omniauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user 
      return user
    else
      existing_user = User.where(email: auth.info["email"]).first
      if existing_user
        return existing_user
      else
        user = User.create(
          email: auth.info.email,
          password: Devise.friendly_token[0,20],
          name: auth.info.name,
          avatar: auth.info.image 
        )
      end
    end
  end

  #rspec
  def self.get_user_count
    User.all.size
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
