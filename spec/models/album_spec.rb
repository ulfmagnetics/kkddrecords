require 'spec_helper'

def valid_album_attributes
  { :title => 'Escape From Oakland',
    :compilation => false,
    :release_date => '2008-10-10' }
end

describe Album do
  before(:each) do
    @band = Band.create(:name => 'Duck Doom Duck')
    @album = Album.new
  end

  it { should validate_presence_of(:title).with_message("is required") }
  it { should validate_presence_of(:release_date).with_message("is required") }

  it { should belong_to(:band) }
  it { should have_many(:tracks) }

  it "by default should not be a compilation" do
    @album.compilation.should_not == true
  end
end
