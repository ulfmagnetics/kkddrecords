class BandsController < ApplicationController
  autocomplete :band, :name

  def index
    @bands = Band.sorted
  end

  def edit
  end

  def create
    @band = Band.new(params[:band])
    if @band.valid?
      @band.save
    end

    redirect_to :action => 'index'
  end
end
