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
  has_many :workspaces, through: :workspace_users, source: :workspace

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

  # メールアドレス
  validates :email,
    presence: true,
    length: { maximum: 256 }

  ##
  # scopes
  ##

  # ワークスペース 外部結合
  scope :with_workspaces, -> {
    eager_load(:workspaces)
  }
end
