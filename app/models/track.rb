class Track < ActiveRecord::Base
  include Bitfields
  bitfield :flags, 1 => :hidden

  include MediaHelper

  validates_presence_of :title
  validates_numericality_of :position
  validates_inclusion_of :format, :in => valid_audio_formats

  has_attached_file :media
  validates_attachment_content_type :media, :content_type => valid_audio_mime_types
  validates_attachment_size :media, :less_than => 250.megabytes
end
