require 'zip/zipfilesystem'

class ExplosionAction
  attr_reader :verb
  attr_reader :model
  attr_reader :zipfs_file

  def initialize(zipfs, entry)
    @zipfile_entry = zipfs_file
  end
end
