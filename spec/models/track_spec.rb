require 'spec_helper'

describe Track do
  before(:each) do
    @track = Track.new
  end

  it { should validate_presence_of(:title) }
  it { should validate_numericality_of(:position) }

  it "should not allow bogus formats" do
    @track.format = 'banana'
    @track.should_not be_valid
    @track.should have(1).error_on(:format)
  end

  it "should not be marked as a hidden track by default" do
    @track.hidden.should_not == true
  end
end
