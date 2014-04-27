class Room < ActiveRecord::Base
  belongs_to :game
  has_many :messages
  before_create :set_order
  default_scope -> { order :order }

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

  protected
    def set_order
      self.order = Room.count game_id: game_id
    end
end
