class Game < ActiveRecord::Base
  has_many :characters
  has_many :rooms

  after_create :add_master

  protected

    def add_master
      Character.create_master self
    end
end
