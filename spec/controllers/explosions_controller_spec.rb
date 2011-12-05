require 'spec_helper'

include ActionDispatch::TestProcess

describe ExplosionsController do
  render_views

  describe "POST create" do
    it "should set an error message in the session if the wrong type of file is uploaded" do
      post :create, :explosion => { :zipfile => fixture_file_upload('/files/deploy-time.jpg', 'image/jpg') }
      controller.should render_template :new
      response.body.should =~ /zipfile content type.*application\/zip/i
    end

    it "should create a new explosion if a valid zipfile is uploaded" do
      expect do
        post :create, :explosion => { :zipfile => fixture_file_upload('/files/album.zip', 'application/zip') }
      end.to change { Explosion.count }.by(1)
      pending "should have correct user id for uploader" do
        explosion = Explosion.last
        explosion.user.id.should == session.user.id  # or something like that
      end
    end
  end
end
