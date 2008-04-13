# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080413080403) do

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.integer  "guild_id"
    t.integer  "server_id"
    t.integer  "race_id"
    t.integer  "gender_id"
    t.integer  "klass_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
    t.integer  "faction_id"
    t.boolean  "inactive",   :default => false
  end

  create_table "factions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guilds", :force => true do |t|
    t.string   "name"
    t.string   "name_sane"
    t.integer  "server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "faction_id"
  end

  create_table "klasses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rep_factions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reputations", :force => true do |t|
    t.integer  "character_id"
    t.integer  "rep_faction_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skill_levels", :force => true do |t|
    t.integer  "character_id"
    t.integer  "skill_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
