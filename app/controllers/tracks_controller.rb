class TracksController < ApplicationController
  def index
    # TODO only load the "above the fold" albums. load more on demand
    @tracks = Track.all
  end
end
