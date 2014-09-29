class Message < ActiveRecord::Base
  include Command

  belongs_to :sender, class_name: 'Character'
  belongs_to :room

  default_scope -> { order(:created_at) }

  def destroy_if_allowed(user)
    return false if user.nil?

    char = room.game.get_character_for user
    return false unless room.readable_by? char

    if char.master || (sender_id == char.id && !is_roll?)
      destroy
      return true
    end

    false
  end

end
