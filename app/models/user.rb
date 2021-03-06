class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :characters

  def name
    read_attribute(:name) || '%username%'
  end

  def to_s
    self.name
  end

  def unread_messages_count
    Game.for(self).reduce(0) do |sum, game|
      sum + game.unread_messages_count(self)
    end
  end

end
