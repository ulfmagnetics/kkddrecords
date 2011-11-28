require 'spec_helper'

describe Band do
  before(:each) do
    @band = Band.new
  end

  it { should validate_presence_of(:name) }

  it { should have_many(:albums) }
end
