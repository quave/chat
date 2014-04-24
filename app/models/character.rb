class Character < ActiveRecord::Base
  validates :color, numericality: { only_integer: true }

  belongs_to :user
  belongs_to :game
end
