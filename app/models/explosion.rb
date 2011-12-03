class Explosion < ActiveRecord::Base
  has_attached_file :zipfile
  validates_attachment_content_type :zipfile, :content_type => 'application/zip'
  validates_attachment_size :zipfile, :less_than => 1.gigabytes
end
