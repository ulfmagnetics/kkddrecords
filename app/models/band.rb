class Band < ActiveRecord::Base
  validates_uniqueness_of :name, :case_sensitive => false

  has_many :albums
end
