require 'spec_helper'

describe Room do
  it { should respond_to :up }
  it { should respond_to :down }

  context 'with order' do
    let(:room1) { Room.create name: 'room1', game_id: 1, order: 1 }
    let(:room2) { Room.create name: 'room2', game_id: 1, order: 2 }
    subject { room1 }

    context 'after down' do
      xit "increases self's order" do
        subject.down
        puts Room.all
        expect(subject.order).to eq(2) 
      end
      
      xit "decreases prev room order" do
        expect {room2.order}.to eq(1) 
      end
    end
  end
end