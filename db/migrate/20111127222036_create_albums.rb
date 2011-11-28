class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.integer       :band_id
      t.string        :title
      t.date          :release_date
      t.integer       :flags,           :default => 0
      t.timestamps
    end

    add_index   :albums,    :band_id
  end

  def self.down
    drop_index  :albums,    :band_id
    drop_table  :albums
  end
end
