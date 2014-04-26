require 'spec_helper'

describe Room do
  it { should respond_to :up }
  it { should respond_to :down }

  context 'with order' do
    let(:room1) { Room.create name: 'room1', game_id: 1, order: 1 }
    let(:room2) { Room.create name: 'room2', game_id: 1, order: 2 }
    subject { room1 }

    context 'after down' do
      # subject.down
      #its(:order) { should == 2 }
      #it { room2.order.should == 1 }
    end
  end
end