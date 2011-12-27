class AddId3TagToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :id3_v1_tag, :text
    add_column :tracks, :id3_v2_tag, :text
  end
end
