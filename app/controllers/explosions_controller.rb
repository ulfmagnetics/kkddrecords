class ExplosionsController < ApplicationController
  def new
    @explosion = Explosion.new
  end

  def create
    @explosion = Explosion.new(params[:explosion])
    unless @explosion.valid?
      render :action => :new
      return
    end
    @explosion.save

    respond_to do |format|
      format.html do
        render :action => :show
      end
      format.js
    end
  end
end
