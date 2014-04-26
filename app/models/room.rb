class Room < ActiveRecord::Base
  belongs_to :game
  has_many :messages

  def up
  end

  def down
  end
end
