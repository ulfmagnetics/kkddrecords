ActiveAdmin.register Track do
  index do
    column :title do |track|
      link_to track.title, admin_track_path(track)
    end
    column :band do |track|
      link_to track.album.band.name, admin_band_path(track.album.band) unless track.album.nil?
    end
    column :album do |track|
      link_to track.album.title, admin_album_path(track.album) unless track.album.nil?
    end
    column "Track #", :position
    column "Length" do |track|
      track.length_string
    end
    column :format
    column :created_at

    default_actions
  end

  form :html => {:enctype => 'multipart/form-data'} do |f|
    # TODO conditionally display this if we're uploading a WAV file
    # f.inputs "Metadata" do
    #   f.input :title
    #   f.input :position
    #   f.input :format, :as => :select, :collection => Track.valid_audio_formats
    # end
    f.inputs "Media" do
      f.input :media, :as => :file, :hint => "MP3 tags will be used to set title, position, band, album, etc."
    end
    f.buttons
  end
end
