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
end
