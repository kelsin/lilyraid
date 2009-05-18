# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090517035127) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "lj_account"
    t.integer  "age"
    t.string   "location"
    t.string   "email"
    t.text     "bio"
    t.boolean  "admin",                    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password",   :limit => 32
  end

  create_table "cclass_roles", :force => true do |t|
    t.integer  "cclass_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cclass_roles", ["cclass_id", "role_id"], :name => "index_cclass_roles_on_cclass_id_and_role_id"
  add_index "cclass_roles", ["cclass_id"], :name => "index_cclass_roles_on_cclass_id"
  add_index "cclass_roles", ["role_id"], :name => "index_cclass_roles_on_role_id"

  create_table "cclasses", :force => true do |t|
    t.string   "name"
    t.string   "color",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.integer  "account_id", :default => 0,     :null => false
    t.string   "name"
    t.integer  "level"
    t.integer  "race_id",    :default => 0,     :null => false
    t.integer  "cclass_id",  :default => 0,     :null => false
    t.string   "guild"
    t.boolean  "inactive",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["account_id"], :name => "index_characters_on_account_id"

  create_table "instances", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true, :null => false
  end

  create_table "list_positions", :force => true do |t|
    t.integer  "list_id",    :default => 0, :null => false
    t.integer  "account_id", :default => 0, :null => false
    t.integer  "position",   :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_positions", ["account_id"], :name => "index_list_positions_on_account_id"
  add_index "list_positions", ["list_id"], :name => "index_list_positions_on_list_id"
  add_index "list_positions", ["position"], :name => "index_list_positions_on_position"

  create_table "lists", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "date"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["date"], :name => "index_lists_on_date"
  add_index "lists", ["name"], :name => "index_lists_on_name"

  create_table "locations", :force => true do |t|
    t.integer  "instance_id"
    t.integer  "raid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["raid_id", "instance_id"], :name => "locations_by_raid_and_instance", :unique => true

  create_table "loots", :force => true do |t|
    t.integer  "character_id", :default => 0, :null => false
    t.integer  "list_id",      :default => 0, :null => false
    t.string   "item_url"
    t.string   "item_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
  end

  add_index "loots", ["character_id"], :name => "index_loots_on_character_id"
  add_index "loots", ["list_id"], :name => "index_loots_on_list_id"

  create_table "races", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raids", :force => true do |t|
    t.string   "name",                                :null => false
    t.datetime "date",                                :null => false
    t.text     "loot_note"
    t.text     "note"
    t.boolean  "locked",           :default => false, :null => false
    t.integer  "account_id",       :default => 0,     :null => false
    t.boolean  "uses_loot_system", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finalized",        :default => false, :null => false
  end

  add_index "raids", ["account_id"], :name => "index_raids_on_account_id"
  add_index "raids", ["date"], :name => "index_raids_on_date"

  create_table "roles", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signup_roles", :force => true do |t|
    t.integer  "signup_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signup_roles", ["role_id"], :name => "index_signup_roles_on_role_id"
  add_index "signup_roles", ["signup_id", "role_id"], :name => "index_signup_roles_on_signup_id_and_role_id"
  add_index "signup_roles", ["signup_id"], :name => "index_signup_roles_on_signup_id"

  create_table "signups", :force => true do |t|
    t.integer  "raid_id",      :default => 0, :null => false
    t.integer  "character_id", :default => 0, :null => false
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signups", ["character_id"], :name => "index_signups_on_character_id"
  add_index "signups", ["created_at"], :name => "index_signups_on_created_at"
  add_index "signups", ["raid_id", "character_id"], :name => "index_signups_on_raid_id_and_character_id"
  add_index "signups", ["raid_id"], :name => "index_signups_on_raid_id"

  create_table "slots", :force => true do |t|
    t.integer  "raid_id"
    t.integer  "cclass_id"
    t.integer  "signup_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_id"
  end

  add_index "slots", ["raid_id"], :name => "index_slots_on_raid_id"
  add_index "slots", ["role_id", "cclass_id"], :name => "index_slots_on_role_id_and_cclass_id"
  add_index "slots", ["signup_id"], :name => "index_slots_on_signup_id"

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :primary_key => "user_id", :force => true do |t|
    t.boolean "user_active",                                                        :default => true
    t.string  "username",              :limit => 25,                                :default => "",          :null => false
    t.string  "user_password",         :limit => 32,                                :default => "",          :null => false
    t.integer "user_session_time",                                                  :default => 0,           :null => false
    t.integer "user_session_page",     :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_lastvisit",                                                     :default => 0,           :null => false
    t.integer "user_regdate",                                                       :default => 0,           :null => false
    t.integer "user_level",            :limit => 1,                                 :default => 0
    t.integer "user_posts",            :limit => 3,                                 :default => 0,           :null => false
    t.decimal "user_timezone",                        :precision => 5, :scale => 2, :default => 0.0,         :null => false
    t.integer "user_style",            :limit => 1
    t.string  "user_lang"
    t.string  "user_dateformat",       :limit => 14,                                :default => "d M Y H:i", :null => false
    t.integer "user_new_privmsg",      :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_unread_privmsg",   :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_last_privmsg",                                                  :default => 0,           :null => false
    t.integer "user_login_tries",      :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_last_login_try",                                                :default => 0,           :null => false
    t.integer "user_emailtime"
    t.boolean "user_viewemail"
    t.boolean "user_attachsig"
    t.boolean "user_allowhtml",                                                     :default => true
    t.boolean "user_allowbbcode",                                                   :default => true
    t.boolean "user_allowsmile",                                                    :default => true
    t.boolean "user_allowavatar",                                                   :default => true,        :null => false
    t.boolean "user_allow_pm",                                                      :default => true,        :null => false
    t.boolean "user_allow_viewonline",                                              :default => true,        :null => false
    t.boolean "user_notify",                                                        :default => true,        :null => false
    t.boolean "user_notify_pm",                                                     :default => false,       :null => false
    t.boolean "user_popup_pm",                                                      :default => false,       :null => false
    t.integer "user_rank",                                                          :default => 0
    t.string  "user_avatar",           :limit => 100
    t.integer "user_avatar_type",      :limit => 1,                                 :default => 0,           :null => false
    t.string  "user_email"
    t.string  "user_icq",              :limit => 15
    t.string  "user_website",          :limit => 100
    t.string  "user_from",             :limit => 100
    t.text    "user_sig"
    t.string  "user_sig_bbcode_uid",   :limit => 10
    t.string  "user_aim"
    t.string  "user_yim"
    t.string  "user_msnm"
    t.string  "user_occ",              :limit => 100
    t.string  "user_interests"
    t.string  "user_actkey",           :limit => 32
    t.string  "user_newpasswd",        :limit => 32
  end

  add_index "users", ["user_session_time"], :name => "user_session_time"

end
