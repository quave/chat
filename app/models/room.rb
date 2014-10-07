# noinspection RubyResolve
class Room < ActiveRecord::Base
  belongs_to :game
  has_many :messages
  has_many :user_visits, class_name: 'RoomsUsersVisit'
  has_and_belongs_to_many :characters

  before_create :set_order
  before_save :check_characters
  default_scope -> { order :order }

  def participants
    if free_readable?
      game.characters
    else
      characters
    end
  end

  def last_visited_by(user)
    visits = Chat::Application::room_user_visits
    if visits.has_key?(user.id) && visits[user.id].include?(id)
      DateTime.now
    else
      visit = user_visits.find_by(user_id: user.id)
      if visit.nil?
        DateTime.new
      else
        visit.last_visited
      end
    end
  end

  def unread_messages_count(user)
    return 0 if user.nil? || Online.exists?(user.id, id)
    messages.where('created_at > ?', last_visited_by(user)).count
  end

  def up!
    prev_room = Room.find_by game_id: self.game_id, order: (self.order - 1)
    return false if prev_room.nil?

    self.order -= 1
    save!
    
    prev_room.order += 1
    prev_room.save!

    true
  end

  def down!
    next_room = Room.find_by game_id: self.game_id, order: (self.order + 1)
    return false if next_room.nil?

    self.order += 1
    save!
    
    next_room.order -= 1
    next_room.save!

    true
  end

  def free_readable?
    character_ids.empty?
  end

  def readable_by?(char)
    return true if free_readable?

    !char.nil? && (char.master || character_ids.include?(char.id))
  end

  def commit_visit(user_id)
    visit = user_visits.find_or_initialize_by user_id: user_id
    visit.last_visited = DateTime.now
    visit.save!
  end

  def self.commit_visit(room_id, user_id)
    find(room_id).commit_visit(user_id)
  end

  def self.show(id, user)
    room = includes(:messages).find id
    room.commit_visit user.id unless user.nil?
    room
  end

  protected
    def set_order
      self.order = game.rooms.count
    end

    def check_characters
      characters.clear if character_ids.sort == game.character_ids.sort
    end
end
