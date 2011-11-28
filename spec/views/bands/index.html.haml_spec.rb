require 'spec_helper'

describe 'bands/index.html.haml' do
  before(:each) do
    @bands = []
    3.times { @bands << Factory(:band) }
  end

  it "displays all the band names" do
    assign(:bands, @bands)
    render
    @bands.each do |band|
      rendered.should =~ /#{band.name}/
    end
  end
end