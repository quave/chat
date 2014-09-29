require 'spec_helper'

describe Room do
  let(:game) { create :game }
  subject(:room) { create :room }

  context 'order' do
    its(:order) { is_expected.to eq(1) }

    it 'decrease after up' do
      room.up!
      expect(room.order).to eq(0)
    end

    it 'the same after up and down' do
      order = room.order
      room.up!
      room.down!
      expect(room.order).to eq(order)
    end
  end

  context 'readability' do
    it 'is free readable' do
      expect(room).to be_free_readable
    end

    it 'is not free readable with a char' do
      char = create(:character, game: room.game)
      room.characters << char

      expect(room).not_to be_free_readable
    end

    it 'is readable by master' do
      master = room.game.characters.first
      expect(room.readable_by? master).to be true
    end

    it 'is readable by master with other chars' do
      master = room.game.characters.first
      char = create(:character, game: room.game)
      room.characters << char

      expect(room.readable_by? master).to be true
    end

    it 'is readable by nil char' do
      expect(room.readable_by? nil).to be true
    end

    it 'is not readable by nil char with other chars' do
      char = create(:character, game: room.game)
      room.characters << char

      expect(room.readable_by? nil).to be false
    end

    it 'is readable by added char' do
      char = create(:character, game: room.game)
      room.characters << char

      expect(room.readable_by? char).to be true
    end

    it 'is readable by a char with other chars' do
      char0 = create(:character, game: room.game)
      char1 = create(:character, game: room.game)
      room.characters << char0

      expect(room.readable_by? char1).to be false
    end

  end

  context 'visit' do
    let(:user) { game.creator }

    context 'before' do
      it 'should not be visited' do
        expect(room.last_visited_by user).to be_nil
      end

      it 'should not be unread messages' do
        expect(room.unread_messages_count user).to eq(0)
      end
    end

    context 'after' do
      it 'should be visited' do
        date = DateTime.now
        room.user_visits << RoomsUsersVisit.new(user_id: user.id, last_visited: date)
        expect(room.last_visited_by(user)).to eq(date)
      end

      it 'should not be unread messages' do
        date = DateTime.new
        room.user_visits << RoomsUsersVisit.new(user_id: user.id, last_visited: date)
        expect(room.unread_messages_count user).to eq(0)
      end

      it 'messages should be read' do
        char = game.characters.first
        room.messages << Message.new(body: 'test1', sender: char)

        date = 2.hours.since
        room.user_visits << RoomsUsersVisit.new(user_id: user.id, last_visited: date)

        expect(room.unread_messages_count user).to eq(0)
      end

      it 'should be two unread messages' do
        char = game.characters.first
        date = 1.day.ago
        room.user_visits << RoomsUsersVisit.new(user_id: user.id, last_visited: date)

        room.messages << Message.new(body: 'test1', sender: char)
        room.messages << Message.new(body: 'test2', sender: char)

        expect(room.unread_messages_count user).to eq(2)
      end
    end
  end

  it 'characters should be empty if includes all' do
    create(:character, game: room.game)
    room.game.reload
    room.characters << room.game.characters
    room.save!
    expect(room.characters).to be_empty
  end
end