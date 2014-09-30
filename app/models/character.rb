class Character < ActiveRecord::Base
  PENDING = 0
  ACTIVE = 1
  REJECTED = 2
  DEAD = 3

  belongs_to :user
  belongs_to :game
  has_and_belongs_to_many :rooms

  validates :color, numericality: { only_integer: true }
  default_scope -> { includes(:user) }

  def self.create_master(game, name = 'Master')
    create name: name, master: true, user_id: game.creator_id, game_id: game.id, status: ACTIVE
  end

  def status_text 
    I18n.t 'game.characters.statuses.' + status.to_s
  end

  def accept
    return if status != PENDING

    status = ACTIVE
    save!
  end

  def decline
    return if status != PENDING

    status = REJECTED
    save!
  end

  def kill
    return if status != ACTIVE

    status = DEAD
    save!
  end

  def in_room?(room_id)
    user.in_room? room_id
  end
end
