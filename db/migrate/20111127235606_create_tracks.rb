class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer         :album_id
      t.string          :title
      t.string          :format
      t.integer         :position
      t.integer         :flags,         :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
