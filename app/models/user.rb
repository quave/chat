class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :name, presence: true
  validate :name, uniqueness: true

  def name
    read_attribute(:name) || '%username%'
  end
end
