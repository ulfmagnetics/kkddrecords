require 'spec_helper'

describe Band do
  before(:each) do
    Factory(:band)
  end

  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should have_many(:albums) }
end
