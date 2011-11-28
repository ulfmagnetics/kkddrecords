class Track < ActiveRecord::Base
  VALID_FORMATS = %w{ mp3 aiff wav flac }

  include Bitfields
  bitfield :flags, 1 => :hidden

  validates_presence_of :title
  validates_numericality_of :position
  validates_inclusion_of :format, :in => VALID_FORMATS
end
