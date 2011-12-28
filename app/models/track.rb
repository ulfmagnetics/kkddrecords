class Track < ActiveRecord::Base
  include MediaHelper
  include Bitfields
  bitfield :flags, 1 => :hidden

  belongs_to :album

  validates_presence_of :title
  validates_numericality_of :position
  validates_inclusion_of :format, :in => valid_audio_formats

  has_attached_file :media,
    :storage => :s3,
    :bucket => S3_CONFIG[Rails.env]["bucket"],
    :s3_credentials => {
      :access_key_id => S3_CONFIG[Rails.env]["access_key_id"],
      :secret_access_key => S3_CONFIG[Rails.env]["secret_access_key"]
    }
  validates_attachment_content_type :media, :content_type => valid_audio_mime_types
  validates_attachment_size :media, :less_than => 250.megabytes

  before_media_post_process :update_format
  before_media_post_process :update_from_id3_tags, :if => Proc.new {|track| self.class.valid_audio_mappings['mp3'].include?(track.media_content_type)}

  before_save :find_or_create_album_from_id3_tags, :if => Proc.new {|track| track.id3_v1_tag.present?}

  def length_string
    (self.length_in_seconds.to_f / 60).floor.to_s.rjust(2, '0') + ':' + (self.length_in_seconds % 60).to_s.rjust(2, '0')
  end

  # See http://jimneath.org/2008/05/15/swfupload-paperclip-and-ruby-on-rails.html
  def swfupload_media=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).try(:first)
    self.media = data
  end

  private

  def update_format
    self.format = self.class.valid_audio_mappings.detect {|format,mime_types| mime_types.include?(media_content_type)}.try(:first)
  end

  def update_from_id3_tags
    Mp3Info.open(media.queued_for_write[:original].path) do |mp3|
      self.title = mp3.tag.title
      self.position = mp3.tag.tracknum
      self.notes = "MPEG #{mp3.mpeg_version} Layer #{mp3.layer} #{mp3.vbr ? "VBR" : "CBR"} #{mp3.bitrate} Kbps #{mp3.channel_mode} #{mp3.samplerate} Hz"
      self.length_in_seconds = mp3.length.round
      self.id3_v1_tag = mp3.tag.try(:to_yaml)
      self.id3_v2_tag = mp3.tag2.try(:to_yaml)
    end
  rescue => ex
    errors.add(:base, "Couldn't update track information from the MP3 tags.")
    Rails.logger.error("Caught exception while updating track info from tags: #{ex.inspect}")
  end

  def find_or_create_album_from_id3_tags
    id3 = YAML::load(self.id3_v1_tag) unless self.id3_v1_tag.blank?
    return unless id3.present? && id3['album'].present? && id3['artist'].present?
    album = Album.joins(:band).where(:albums => {:title => id3['album']}, :bands => {:name => id3['artist']}).first
    if album.blank?
      album = Album.new
      album.band = Band.where(:name => id3['artist']).first || Band.create(:name => id3['artist'])
      album.title = id3['album']
      album.save
    end
    self.album = album
  rescue => ex
    errors.add(:base, "Couldn't create album and/or band from MP3 tags.")
    Rails.logger.error("Caught exception while creating album from tags: #{ex.inspect}")
  end
end
