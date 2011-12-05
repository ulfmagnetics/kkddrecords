require 'spec_helper'
require 'zip/zipfilesystem'

include ActionDispatch::TestProcess

describe Explosion do
  it { should have_attached_file(:zipfile) }
  it { should validate_attachment_content_type(:zipfile).allowing('application/zip').rejecting('text/plain') }
  it { should validate_attachment_size(:zipfile).less_than(1.gigabytes) }

  before(:all) do
    # album.zip contents:
    # Dark Habitat - Cold Friend (WAV)/
    # Dark Habitat - Cold Friend (WAV)/.DS_Store
    # Dark Habitat - Cold Friend (WAV)/01 Cold Friend (rough mix).mp3
    # Dark Habitat - Cold Friend (WAV)/02 Haunted Chair (rough mix).mp3
    # Dark Habitat - Cold Friend (WAV)/1 Cold Friend rough mix.wav
    # Dark Habitat - Cold Friend (WAV)/2 Haunted Chair rough mix.wav
    # Dark Habitat - Cold Friend (WAV)/cover.jpg
    # Dark Habitat - Cold Friend (WAV)/ignorable_file.rtf
    # Dark Habitat - Cold Friend (WAV)/useless_subfolder/
    # Dark Habitat - Cold Friend (WAV)/useless_subfolder/deploy-time.jpg
    # __MACOSX/
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/._.DS_Store
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/._01 Cold Friend (rough mix).mp3
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/._02 Haunted Chair (rough mix).mp3
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/._1 Cold Friend rough mix.wav
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/._2 Haunted Chair rough mix.wav
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/._cover.jpg
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/._ignorable_file.rtf
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/useless_subfolder/
    # __MACOSX/Dark Habitat - Cold Friend (WAV)/useless_subfolder/._deploy-time.jpg
    @album_zip = File.new("#{RSpec.configuration.fixture_path}/files/album.zip")
    @explosion = Explosion.create(valid_explosion_params)
    @explosion.zipfile = @album_zip
    @explosion.save
  end

  def valid_explosion_params
    {}
  end

  describe "target_directory" do
    it "should return the first directory alphabetically under root" do
      @explosion.target_directory.should == 'Dark Habitat - Cold Friend (WAV)'
    end
  end

  describe "warnings" do
    it "should tell user that top-level directories other than the first one will be ignored" do
      @explosion.warnings.should be_any { |w| w =~ /ignoring.*directory.*__MACOSX/ }
    end

    it "should tell user that subfolders will be ignored" do
      @explosion.warnings.should be_any { |w| w =~ /ignoring.*directory.*useless_subfolder/ }
    end

    it "should warn user about files in unknown formats" do
      @explosion.warnings.should be_any { |w| w =~ /ignoring.*file.*ignorable_file.rtf/ }
    end
  end

  describe "actions" do
    pending "should contain actions for all of the media files in the target directory"
  end

  it "build a state machine to manage the transitions through various phases of upload/processing?"
  it "should belong to the user who uploaded it"
end