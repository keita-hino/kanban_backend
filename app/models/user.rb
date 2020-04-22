class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  ##
  # relations
  ##

  has_many :workspace_users

  ##
  # validates
  ##

  # 姓
  validates :last_name,
    presence: true,
    length: { maximum: 20 }

  # 名
  validates :first_name,
    presence: true,
    length: { maximum: 20 }
end
