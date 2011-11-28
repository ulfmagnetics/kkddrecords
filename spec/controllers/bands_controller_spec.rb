require 'spec_helper'

describe BandsController do
  before(:each) do
    @bands = []
    3.times do
      @bands << Factory(:band)
    end
  end

  describe 'GET index' do
    it "should assign all bands to @bands" do
      get :index
      assigns(:bands).should == @bands
    end
  end
end
