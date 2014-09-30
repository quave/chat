class User < ActiveRecord::Base
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

  def visit_room(room_id)
    visits = Chat::Application::room_user_visits
    visits[id] ||= Set.new
    visits[id] << room_id
  end

  def leave_room(room_id)
    visits = Chat::Application::room_user_visits

    if visits.has_key? id
      visits[id].delete room_id

      visits.delete(id) if visits[id].empty?
    end
  end

  def in_room?(room_id)
    visits = Chat::Application::room_user_visits
    visits.has_key?(id) && visits[id].include?(room_id)
  end

end
