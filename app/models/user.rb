class User < ActiveRecord::Base
  default_scope -> { includes :characters }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :name, presence: true
  validate :name, uniqueness: true

  has_many :characters

  def name
    read_attribute(:name) || '%username%'
  end
end
