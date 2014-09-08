class Game < ActiveRecord::Base
  has_many :characters
  has_many :rooms

  after_create :add_master
  after_create :add_default_rooms

  protected

    def add_master
      Character.create_master self
    end

    def add_default_rooms
      Room.create name: 'Обсуждение', game_id: id
    end
end
