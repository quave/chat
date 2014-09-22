require 'spec_helper'

describe Room do
  let(:game) { create :game }
  subject(:room) { create :room }

  it { should respond_to :up! }
  it { should respond_to :down! }

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

  it 'characters should be empty if includes all' do
    create(:character, game: room.game)
    room.game.reload
    room.characters << room.game.characters
    room.save!
    expect(room.characters).to be_empty
  end
end