require 'spec_helper'

describe Room do
  it { should respond_to :up! }
  it { should respond_to :down! }

  context 'order' do
    let(:room1) { Room.new name: 'room1', game_id: 1 }
    let(:room2) { Room.new name: 'room2', game_id: 1 }
    before :all do
      room1.save
      room2.save
    end

    it { expect(room1.order).to eq(0)}
    it { expect(room2.order).to eq(1)}

    context 'after down' do
      before(:all) do
        room1.down!
        room2.reload
      end
      it { expect(room1.order).to eq(1) }
      it { expect(room2.order).to eq(0) }

      it 'order counts' do
        expect(Room.first.id).to eq(room2.id)
      end
    end

    context 'after up' do
      before(:all) do
        room2.up!
        room1.reload
      end
      it { expect(room1.order).to eq(1) }
      it { expect(room2.order).to eq(0) }
    end
  end
end