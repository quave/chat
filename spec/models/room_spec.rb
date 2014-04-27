require 'spec_helper'

describe Room do
  it { should respond_to :up! }
  it { should respond_to :down! }

  context 'with order' do
    let(:room1) { Room.new name: 'room1', game_id: 1 }
    let(:room2) { Room.new name: 'room2', game_id: 1 }
    before :all do
      room1.save
      room2.save
    end

    it { expect(room1.order).to eq(0)}
    it { expect(room2.order).to eq(1)}

    context 'after down' do
      it { expect{ room1.down! }.to change{ room1.order }.from(0).to(1) }
      it { expect{ room1.down! }.to change{ room2.order }.from(1).to(0) }
    end
  end
end