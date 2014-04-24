class Room < ActiveRecord::Base
  belongs_to :game

  validates :order, numericality: { only_integer: true }
end
