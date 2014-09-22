require 'spec_helper'

describe Game do
  subject(:game) { create(:game) }

  it { should be_valid }
end