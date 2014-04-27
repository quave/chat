class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :user, class_name: 'User'
  belongs_to :room
end
