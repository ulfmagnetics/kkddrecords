require 'spec_helper'

describe Track do
  before(:each) do
    @track = Track.new
  end

  it { should validate_presence_of(:title) }
  it { should validate_numericality_of(:position) }
  it { should have_attached_file(:media) }
  it { should validate_attachment_content_type(:media).allowing('audio/mp3', 'audio/wav').rejecting('text/plain') }
  it { should validate_attachment_size(:media).less_than(250.megabytes) }

  it "should not allow bogus formats" do
    @track.format = 'banana'
    @track.should_not be_valid
    @track.should have(1).error_on(:format)
  end

  it "should not be marked as a hidden track by default" do
    @track.hidden.should_not == true
  end

  pending "should set the format attribute once media is attached"
end
