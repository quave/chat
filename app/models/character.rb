class Character < ActiveRecord::Base
  validates :color, numericality: { only_integer: true }

  belongs_to :user
  belongs_to :game

  def self.create_master(game)
    create({ name: 'Master', desc: '', user_id: game.creator_id, game_id: game.id})
  end
end
