class Message < ActiveRecord::Base
  default_scope -> { order(:created_at) }

  belongs_to :sender, class_name: 'User'
  belongs_to :user, class_name: 'User'
  belongs_to :room

  @@roll_regex = /^\\roll (\d+)?d(\d+)\+?(\d+)?/
  @@roll_bases = [2, 3, 4, 6, 8, 10, 12, 20, 100]

  def character
    sender.characters.find_by(game_id: room.game_id)
  end

  def is_command?
    return body.start_with? '\\'
  end

  def should_save?
    body !~ /^(\\help)|(\\nosave)/
  end

  def exec!
    return unless is_command?
    body.strip!
    roll!
    body.sub! /^\\/, ''
  end

  def roll!
    match = body.match @@roll_regex
    return unless match

    times = match[1] ? match[1].to_i : 1 
    base = match[2] ? match[2].to_i : 1
    add = match[3] ? match[3].to_i : 0

    return unless @@roll_bases.include? base and times <= 10
    result = add
    text = ''

    (1..times).each do |t|
      roll = rand(base) + 1
      result += roll
      text += roll.to_s + ' '
    end

    if add > 0
      text += add.to_s
    else
      text.sub! /\s$/, ''
    end

    text = times > 1 ? ' (' + text + ')' : ''

    body.sub! /^\\roll\s/, ''
    self.body = "#roll#кинул #{body.to_s} и получил #{result.to_s}#{text}"
  end

end
