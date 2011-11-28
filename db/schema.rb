# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111128004245) do

  create_table "albums", :force => true do |t|
    t.integer  "band_id"
    t.string   "title"
    t.date     "release_date"
    t.integer  "flags",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "albums", ["band_id"], :name => "index_albums_on_band_id"

  create_table "bands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", :force => true do |t|
    t.integer  "album_id"
    t.string   "title"
    t.string   "format"
    t.integer  "position"
    t.integer  "flags",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
  end

end
