class ExplosionsController < ApplicationController
  def new
    @explosion = Explosion.new
  end

  def create
    @explosion = Explosion.new(params[:explosion])
    unless @explosion.valid?
      puts @explosion.errors.inspect
      render :action => :new
      return
    end

    respond_to do |format|
      format.html do
        render :action => :show
      end
      format.js
    end
  end
end
