class CreateExplosions < ActiveRecord::Migration
  def self.up
    create_table :explosions do |t|
      t.integer       :user_id
      t.string        :zipfile_file_name
      t.string        :zipfile_content_type
      t.integer       :zipfile_file_size
      t.datetime      :zipfile_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :explosions
  end
end
