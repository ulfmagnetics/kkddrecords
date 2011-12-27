ActiveAdmin.register Track do
  form :html => {:enctype => 'multipart/form-data'} do |f|
    f.inputs "Metadata" do
      f.input :title
      f.input :position
      f.input :format, :as => :select, :collection => Track.valid_audio_formats
    end
    f.inputs "Media" do
      f.input :media, :as => :file, :hint => "MP3 tags will be used to set title, position, band, album, etc."
    end
    f.buttons
  end
end
