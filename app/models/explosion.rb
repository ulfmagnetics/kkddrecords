require 'zip/zipfilesystem'

class Explosion < ActiveRecord::Base
  include MediaHelper

  def self.zipfile_storage_path
    storage_root = if Rails.env.to_s == 'test'
      ":rails_root/spec/tmp/"
    else
      ":rails_root/public/system/"
    end
    storage_root + ":attachment/:id/:style/:filename"
  end

  has_attached_file :zipfile, :path => zipfile_storage_path
  validates_attachment_content_type :zipfile, :content_type => 'application/zip'
  validates_attachment_size :zipfile, :less_than => 1.gigabytes

  attr_accessor :actions
  attr_accessor :warnings

  after_initialize do |explosion|
    explosion.actions = []
    explosion.warnings = []
  end

  after_save :create_actions

  def create_actions
    return if zipfile.path.nil?

    zipfs.dir.entries('/').select { |entry| entry != target_directory }.each { |entry| add_ignore_warning_for(entry) }
    zipfs.dir.chdir(target_directory)
    zipfs.dir.entries('.').each do |entry|
      if zipfs.file.directory?(entry)
        add_ignore_warning_for(entry)
      elsif zipfs.file.file?(entry) && !self.class.valid_file_extensions.include?(zipfs.file.basename(entry).split(".").last)
        add_ignore_warning_for(entry)
      else
        @actions << ExplosionAction.new(zipfs, entry)
      end
    end
    zipfs.dir.chdir('/')
  rescue ZipError => ex
    @warnings << "The zip file you uploaded is invalid. Here's more information: #{ex}"
  end

  def target_directory
    @target_directory ||= zipfs.dir.entries('/').detect { |entry| zipfs.file.directory?(entry) }
  end

  def zipfs
    @zipfs ||= Zip::ZipFile.open(zipfile.path)
  end

  def add_ignore_warning_for(entry)
    type = zipfs.file.directory?(entry) ? "directory" : "file"
    @warnings << "I'm ignoring the #{type} named '#{entry}'."
  end
end
