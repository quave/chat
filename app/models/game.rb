class Game < ActiveRecord::Base
  has_many :characters
  has_many :rooms
  belongs_to :creator, class_name: 'User'

  after_create :add_master
  after_create :add_default_rooms

  def masters
    characters.where master: true
  end

  def rooms_to_display(user)
    char = characters.find { |c| c.user_id == user.id }
    if char.master
      rooms
    else
      rooms.select {|r| r.readable_by? char}
    end
  end

  protected

    def add_master
      Character.create_master self
    end

    def add_default_rooms
      Room.create name: 'Обсуждение', game_id: id
    end
end
