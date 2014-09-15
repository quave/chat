require 'spec_helper'

describe Room do
  let(:game) { Game.create name: 'test_game', creator_id: 1 }
  subject(:room) { Room.create name: 'room1', game: game }

  it { should respond_to :up! }
  it { should respond_to :down! }

  context 'order' do
    its(:order) { is_expected.to eq(1) }

    it 'decrease after up' do
      room.up!
      expect(room.order).to eq(0)
    end

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

  it 'should be empty with masters only' do
    room.characters << game.characters
    room.save!
    expect(room.characters.count).to eq(0)
  end

  it 'should include masters if not empty' do
    room.characters << Character.create(name: 'char', user_id: 1, game: game)
    room.save!
    expect(room.characters.count).to be > 1
  end
end