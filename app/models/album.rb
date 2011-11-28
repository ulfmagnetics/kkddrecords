class Album < ActiveRecord::Base
  include Bitfields
  bitfield :flags, 1 => :compilation

  belongs_to :band
  has_many :tracks

  validates_presence_of :title, :message => "is required"
  validates_presence_of :release_date, :message => "is required"
end
