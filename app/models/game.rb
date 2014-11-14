class Game < ActiveRecord::Base
  NOT_STARTED = 1
  STARTED = 2
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
  scope :with_master, ->(user) { where creator: user.try(:id) }
  scope :with_player, ->(user) do
    joins(:characters)
    .where "characters.user_id = :user_id AND creator_id != :user_id AND status IN :statuses",
           { user_id: user.try(:id), statuses: [NOT_STARTED, STARTED] }
  end
  scope :not_started, -> { where status: Game::NOT_STARTED }
  scope :started, -> { where status: Game::STARTED }

  def start_by(user)
    return unless self.creator == user
    self.status = STARTED
    self.save
  end

  def stop_by(user)
    return unless self.creator == user
    self.status = OVER
    self.save
  end

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
