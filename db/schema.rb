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

ActiveRecord::Schema.define(:version => 16) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "lj_account"
    t.integer  "age"
    t.string   "location"
    t.string   "email"
    t.boolean  "admin",      :default => false, :null => false
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attunements", :force => true do |t|
    t.integer  "character_id"
    t.integer  "instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attunements", ["character_id", "instance_id"], :name => "index_attunements_on_character_id_and_instance_id"
  add_index "attunements", ["instance_id"], :name => "index_attunements_on_instance_id"
  add_index "attunements", ["character_id"], :name => "index_attunements_on_character_id"

  create_table "cclass_roles", :force => true do |t|
    t.integer  "cclass_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cclass_roles", ["cclass_id", "role_id"], :name => "index_cclass_roles_on_cclass_id_and_role_id"
  add_index "cclass_roles", ["role_id"], :name => "index_cclass_roles_on_role_id"
  add_index "cclass_roles", ["cclass_id"], :name => "index_cclass_roles_on_cclass_id"

  create_table "cclasses", :force => true do |t|
    t.string   "name"
    t.string   "color",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.integer  "account_id",                    :null => false
    t.integer  "race_id",                       :null => false
    t.integer  "cclass_id",                     :null => false
    t.string   "name"
    t.string   "guild"
    t.integer  "level"
    t.boolean  "inactive",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["account_id"], :name => "index_characters_on_account_id"

  create_table "instances", :force => true do |t|
    t.string   "name"
    t.boolean  "requires_key", :default => false, :null => false
    t.integer  "max_number"
    t.integer  "min_level"
    t.integer  "max_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "list_positions", :force => true do |t|
    t.integer  "list_id",    :null => false
    t.integer  "account_id", :null => false
    t.integer  "position",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_positions", ["position"], :name => "index_list_positions_on_position"
  add_index "list_positions", ["account_id"], :name => "index_list_positions_on_account_id"
  add_index "list_positions", ["list_id"], :name => "index_list_positions_on_list_id"

  create_table "lists", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "date",       :null => false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["date"], :name => "index_lists_on_date"
  add_index "lists", ["name"], :name => "index_lists_on_name"

  create_table "loots", :force => true do |t|
    t.integer  "character_id", :null => false
    t.integer  "raid_id",      :null => false
    t.integer  "list_id",      :null => false
    t.string   "item_url"
    t.string   "item_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loots", ["list_id"], :name => "index_loots_on_list_id"
  add_index "loots", ["raid_id"], :name => "index_loots_on_raid_id"
  add_index "loots", ["character_id"], :name => "index_loots_on_character_id"

  create_table "preferences", :force => true do |t|
    t.string   "key",        :null => false
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["key"], :name => "index_preferences_on_key"

  create_table "races", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raids", :force => true do |t|
    t.string   "name"
    t.datetime "date",                                :null => false
    t.integer  "min_level"
    t.integer  "max_level"
    t.text     "note"
    t.text     "loot_note"
    t.boolean  "uses_loot_system", :default => false, :null => false
    t.boolean  "locked",           :default => false, :null => false
    t.integer  "instance_id",                         :null => false
    t.integer  "account_id",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raids", ["date"], :name => "index_raids_on_date"
  add_index "raids", ["account_id"], :name => "index_raids_on_account_id"

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signup_roles", :force => true do |t|
    t.integer  "signup_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signup_roles", ["signup_id", "role_id"], :name => "index_signup_roles_on_signup_id_and_role_id"
  add_index "signup_roles", ["role_id"], :name => "index_signup_roles_on_role_id"
  add_index "signup_roles", ["signup_id"], :name => "index_signup_roles_on_signup_id"

  create_table "signups", :force => true do |t|
    t.integer  "raid_id",      :null => false
    t.integer  "character_id", :null => false
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signups", ["raid_id", "character_id"], :name => "index_signups_on_raid_id_and_character_id"
  add_index "signups", ["created_at"], :name => "index_signups_on_created_at"
  add_index "signups", ["character_id"], :name => "index_signups_on_character_id"
  add_index "signups", ["raid_id"], :name => "index_signups_on_raid_id"

  create_table "slots", :force => true do |t|
    t.integer  "raid_id",                      :null => false
    t.integer  "signup_id"
    t.integer  "role_id"
    t.integer  "cclass_id"
    t.boolean  "closed",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slots", ["role_id", "cclass_id"], :name => "index_slots_on_role_id_and_cclass_id"
  add_index "slots", ["signup_id"], :name => "index_slots_on_signup_id"
  add_index "slots", ["raid_id"], :name => "index_slots_on_raid_id"

end
