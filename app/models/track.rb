class Track < ActiveRecord::Base
  include Bitfields
  bitfield :flags, 1 => :hidden

  include MediaHelper

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
  before_media_post_process :update_from_id3_tags, :if => Proc.new { |track| track.media_content_type == 'audio/mp3' }

  private
  
  def update_format
    self.format = Track.valid_audio_mappings.detect {|format,mime_types| mime_types.include?(media_content_type)}.try(:first)
  end

  def update_from_id3_tags
    Mp3Info.open(media.queued_for_write[:original].path) do |mp3|
      self.title = mp3.tag.title
      self.position = mp3.tag.tracknum
      self.notes = "MPEG #{mp3.mpeg_version} Layer #{mp3.layer} #{mp3.vbr ? "VBR" : "CBR"} #{mp3.bitrate} Kbps #{mp3.channel_mode} #{mp3.samplerate} Hz"
      self.length_in_seconds = mp3.length.round
    end
  end
end
