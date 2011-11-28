require 'spec_helper'

describe BandsController do
  describe 'GET index' do
    it "should assign all bands to @bands in sorted order" do
      @bands = []
      3.times { @bands << Factory(:band) }
      get :index
      assigns(:bands).should == @bands.sort { |a,b| a.name <=> b.name }
    end
  end

  describe 'POST create' do
    before do
      @valid_band_attributes = { :name => Faker::Company.name }
    end

    it 'should create a new band with valid params' do
      lambda { post :create, :band => @valid_band_attributes }.should change(Band, :count).from(0).to(1)
      response.should redirect_to(:action => 'index')
    end

    it "should not create a new band with invalid params" do
      attrs = @valid_band_attributes.except(:name)
      lambda { post :create, :band => attrs }.should_not change(Band, :count)
      response.should redirect_to(:action => 'index')
    end
  end
end
