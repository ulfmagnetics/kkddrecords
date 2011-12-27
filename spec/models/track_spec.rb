require 'spec_helper'

include ActionDispatch::TestProcess

describe Track do
  before(:each) do
    @track = Track.new
    @track.stub(:save_attached_files).and_return(true)
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

  context "when media is attached" do
    before(:each) do
      @track.media = fixture_file_upload('/files/track.mp3', 'audio/mp3')
      @track.save
    end

    it "should set the format attribute" do
      @track.format.should == 'mp3'
    end

    context "when ID3 tag contains an album and artist" do
      before(:each) do
        Band.destroy_all
        Album.destroy_all
        @id3_hash = {"title"=>"Judy", "artist"=>"The American Jobs", "album"=>"Feonix", "tracknum"=>3, "comments"=>"0", "genre_s"=>"Rock"}
        @track.id3_v1_tag = @id3_hash.to_yaml
      end

      it "should create the band and album if they don't exist" do
        @track.save
        Band.first.should satisfy {|band| band.name == @id3_hash['artist']}
        Album.first.should satisfy {|album| album.title == @id3_hash['album']}
        @track.album.should == Album.first
        @track.album.band.should == Band.first
      end

      it "should associate the album with the track if it already exists" do
        band = Band.create(:name => @id3_hash['artist'])
        album = Album.create(:band => band, :title => @id3_hash['album'])
        expect {@track.save}.to_not change {Album.count}
        @track.album.should == album
      end

      it "should create a new album for an existing band" do
        band = Band.create(:name => @id3_hash['artist'])
        expect {@track.save}.to change {Album.count}.by(1)
        @track.album.band.should == band
      end

      it "should not associate an album by a different band with the track" do
        band = Band.create(:name => @id3_hash['artist'] + " UK")
        album = Album.create(:band => band, :title => @id3_hash['album'])
        expect {@track.save}.to change {Album.count}.by(1)
        @track.album.should_not == album
        @track.album.band.should_not == band
        @track.album.should satisfy {|a| a.title == @id3_hash['album']}
      end
    end
  end
end
