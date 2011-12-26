class AddMetadataFieldsToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :length_in_seconds, :integer
    add_column :tracks, :notes, :text
  end
end
