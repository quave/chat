class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'Character'
  belongs_to :room

  default_scope -> { order(:created_at) }

  ROLL_REGEX = /^\\roll (\d+)?d(\d+)\+?(\d+)?/
  ROLL_BASES = [2, 3, 4, 6, 8, 10, 12, 20, 100]

  before_save :exec_and_check

  def is_command?
    body.start_with? '\\'
  end

  def is_roll?
    body =~ /^\#roll\#/
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
    match = body.match ROLL_REGEX
    return unless match

    times = match[1] ? match[1].to_i : 1 
    base = match[2] ? match[2].to_i : 1
    add = match[3] ? match[3].to_i : 0

    return unless ROLL_BASES.include? base and times <= 10
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

  def destroy_if_allowed(user)
    return false if user.nil?

    char = room.game.get_character_for user
    return false unless room.readable_by? char

    if char.master || (sender_id == char.id && !is_roll?)
      destroy
      return true
    end

    false
  end

  private

  def exec_and_check
    exec!
    created_at = DateTime.now unless should_save?
    should_save?
  end

end
