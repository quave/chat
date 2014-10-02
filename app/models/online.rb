class Online
  def initialize(id, user_id, room_id)
    visits = Chat::Application::room_user_visits
    visits[id] = [user_id, room_id]
  end

  def self.destroy(id)
    visits = Chat::Application::room_user_visits
    if visits.has_key? id
      data = visits[id]
      visits.delete id
      data
    else
      nil
    end
  end

  def self.exists?(user_id, room_id)
    visits = Chat::Application::room_user_visits
    visits.has_value? [user_id, room_id]
  end
end