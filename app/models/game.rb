class Game < ActiveRecord::Base
  ON = 1
  OVER = 0

  has_many :characters
  has_many :rooms
  belongs_to :creator, class_name: 'User'

  after_create :add_master
  after_create :add_default_rooms

  scope :for, ->(user) do
    joins(:characters)
    .where characters: { user_id: user.try(:id) }
  end
  scope :active, -> { where status: Game::ON }

  def masters
    characters.where master: true
  end

  def unread_messages_count(user)
    return 0 unless in_party?(user)

    rooms_to_display(user).reduce(0) do |sum, room|
      sum + room.unread_messages_count(user)
    end
  end

  def in_party?(user)
    if user.nil?
      nil
    else
      characters.exists? user_id: user.id
    end
  end

  def get_character_for(user)
    if user.nil?
      nil
    else
      characters.find { |c| c.user_id == user.id }
    end
  end

  def rooms_to_display(user)
    char = get_character_for user
    return rooms.select {|r| r.free_readable?} if char.nil?

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
