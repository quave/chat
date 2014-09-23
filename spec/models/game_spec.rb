require 'spec_helper'

describe Game do
  subject(:game) { create(:game) }

  it { should be_valid }

  it { expect(game.rooms.count).to eq(1) }
  it { expect(game.characters.count).to eq(1) }

  it 'should have master' do
    expect(game.characters.first.master).to be true
  end

  context 'rooms to display list' do
    let!(:room_1) { create(:room, name: 'room1', game: game) }
    let!(:room_2) { create(:room, name: 'room1', game: game) }
    let!(:char_1) { create(:character, game: game) }
    let!(:char_2) { create(:character, game: game) }

    it 'should be full for anonymous' do
      expect(game.rooms_to_display(nil).count).to eq(3)
    end

    it 'should be full for master if restricted' do
      room_1.characters << char_1
      master = game.characters.first
      expect(game.rooms_to_display(master.user).count).to eq(3)
    end

    it 'should be full for first char' do
      room_1.characters << char_1
      expect(game.rooms_to_display(char_1.user).count).to eq(3)
    end

    it 'should be restricted for second char' do
      room_1.characters << char_1
      expect(game.rooms_to_display(char_2.user).count).to eq(2)
    end
  end
end