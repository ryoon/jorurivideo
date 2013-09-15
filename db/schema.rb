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

ActiveRecord::Schema.define(:version => 0) do

  create_table "article_areas", :force => true do |t|
    t.integer  "unid"
    t.integer  "parent_id",                :null => false
    t.integer  "content_id"
    t.string   "state",      :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_no",                 :null => false
    t.integer  "sort_no"
    t.integer  "layout_id"
    t.string   "name"
    t.text     "title"
    t.text     "zip_code"
    t.text     "address"
    t.text     "tel"
    t.text     "site_uri"
  end

  create_table "article_attributes", :force => true do |t|
    t.integer  "unid"
    t.integer  "content_id"
    t.string   "state",      :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_no"
    t.integer  "layout_id"
    t.string   "name"
    t.text     "title"
  end

  create_table "article_categories", :force => true do |t|
    t.integer  "unid"
    t.integer  "parent_id",                :null => false
    t.integer  "content_id"
    t.string   "state",      :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_no",                 :null => false
    t.integer  "sort_no"
    t.integer  "layout_id"
    t.string   "name"
    t.text     "title"
  end

  create_table "article_docs", :force => true do |t|
    t.integer  "unid"
    t.integer  "content_id"
    t.string   "state",         :limit => 15
    t.string   "agent_state",   :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "recognized_at"
    t.datetime "published_at"
    t.integer  "language_id"
    t.string   "category_ids"
    t.string   "attribute_ids"
    t.string   "area_ids"
    t.string   "rel_doc_ids"
    t.text     "notice_state"
    t.text     "recent_state"
    t.text     "list_state"
    t.text     "event_state"
    t.date     "event_date"
    t.string   "name"
    t.text     "title"
    t.text     "head",          :limit => 2147483647
    t.text     "body",          :limit => 2147483647
    t.text     "mobile_title"
    t.text     "mobile_body",   :limit => 2147483647
  end

  add_index "article_docs", ["content_id", "published_at", "event_date"], :name => "content_id"

  create_table "article_sections", :force => true do |t|
    t.integer  "unid"
    t.integer  "content_id"
    t.string   "state",       :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.string   "code"
    t.string   "parent_code"
    t.text     "group_ids"
    t.integer  "level_no"
    t.integer  "sort_no"
    t.string   "name"
    t.text     "title"
    t.text     "tel"
    t.string   "email"
    t.text     "outline_uri"
  end

  add_index "article_sections", ["id"], :name => "id"

  create_table "article_tags", :force => true do |t|
    t.integer  "unid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "word"
  end

  create_table "cms_concepts", :force => true do |t|
    t.integer  "unid"
    t.integer  "parent_id"
    t.integer  "site_id"
    t.string   "state",      :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_no",                 :null => false
    t.integer  "sort_no"
    t.string   "name"
  end

  add_index "cms_concepts", ["parent_id", "state", "sort_no"], :name => "parent_id"

  create_table "cms_contents", :force => true do |t|
    t.integer  "unid"
    t.integer  "concept_id"
    t.integer  "site_id",                              :null => false
    t.string   "state",          :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model"
    t.string   "name"
    t.text     "xml_properties", :limit => 2147483647
  end

  create_table "cms_data_file_nodes", :force => true do |t|
    t.integer  "unid"
    t.integer  "site_id"
    t.integer  "concept_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "title"
  end

  add_index "cms_data_file_nodes", ["concept_id", "name"], :name => "concept_id"
  add_index "cms_data_file_nodes", ["concept_id", "name"], :name => "concept_id_2"

  create_table "cms_data_files", :force => true do |t|
    t.integer  "unid"
    t.integer  "site_id"
    t.integer  "concept_id"
    t.integer  "node_id"
    t.string   "state",        :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "name"
    t.text     "title"
    t.text     "mime_type"
    t.integer  "size"
    t.integer  "image_is"
    t.integer  "image_width"
    t.integer  "image_height"
  end

  add_index "cms_data_files", ["concept_id", "node_id", "name"], :name => "concept_id"

  create_table "cms_data_texts", :force => true do |t|
    t.integer  "unid"
    t.integer  "site_id"
    t.integer  "concept_id"
    t.string   "state",        :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "name"
    t.text     "title"
    t.text     "body",         :limit => 2147483647
  end

  create_table "cms_inquiries", :force => true do |t|
    t.string   "state",      :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "group_id"
    t.text     "charge"
    t.text     "tel"
    t.text     "fax"
    t.text     "email"
  end

  create_table "cms_kana_dictionaries", :force => true do |t|
    t.integer  "unid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "body",        :limit => 2147483647
    t.text     "ipadic_body", :limit => 2147483647
    t.text     "unidic_body", :limit => 2147483647
  end

  create_table "cms_layouts", :force => true do |t|
    t.integer  "unid"
    t.integer  "concept_id"
    t.integer  "template_id"
    t.integer  "site_id",                                 :null => false
    t.string   "state",             :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "recognized_at"
    t.datetime "published_at"
    t.string   "name"
    t.text     "title"
    t.text     "head",              :limit => 2147483647
    t.text     "body",              :limit => 2147483647
    t.text     "stylesheet",        :limit => 2147483647
    t.text     "mobile_head"
    t.text     "mobile_body",       :limit => 2147483647
    t.text     "mobile_stylesheet", :limit => 2147483647
  end

  create_table "cms_maps", :force => true do |t|
    t.integer  "unid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "title"
    t.text     "map_lat"
    t.text     "map_lng"
    t.text     "map_zoom"
    t.text     "point1_name"
    t.text     "point1_lat"
    t.text     "point1_lng"
    t.text     "point2_name"
    t.text     "point2_lat"
    t.text     "point2_lng"
    t.text     "point3_name"
    t.text     "point3_lat"
    t.text     "point3_lng"
    t.text     "point4_name"
    t.text     "point4_lat"
    t.text     "point4_lng"
    t.text     "point5_name"
    t.text     "point5_lat"
    t.text     "point5_lng"
  end

  create_table "cms_nodes", :force => true do |t|
    t.integer  "unid"
    t.integer  "concept_id"
    t.integer  "site_id"
    t.string   "state",         :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "recognized_at"
    t.datetime "published_at"
    t.integer  "parent_id"
    t.integer  "route_id"
    t.integer  "content_id"
    t.string   "model"
    t.integer  "directory"
    t.integer  "layout_id"
    t.string   "name"
    t.text     "title"
    t.text     "body",          :limit => 2147483647
    t.text     "mobile_title"
    t.text     "mobile_body",   :limit => 2147483647
  end

  add_index "cms_nodes", ["parent_id", "name"], :name => "parent_id"

  create_table "cms_pieces", :force => true do |t|
    t.integer  "unid"
    t.integer  "concept_id"
    t.integer  "site_id",                              :null => false
    t.string   "state",          :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "recognized_at"
    t.datetime "published_at"
    t.integer  "content_id"
    t.string   "model"
    t.string   "name"
    t.text     "title"
    t.text     "head",           :limit => 2147483647
    t.text     "body",           :limit => 2147483647
    t.text     "xml_properties", :limit => 2147483647
  end

  add_index "cms_pieces", ["concept_id", "name", "state"], :name => "concept_id"

  create_table "cms_sites", :force => true do |t|
    t.integer  "unid"
    t.string   "state",           :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "full_uri"
    t.string   "mobile_full_uri"
    t.integer  "node_id"
    t.text     "related_site"
    t.string   "map_key"
  end

  create_table "cms_talk_tasks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.integer  "content_id"
    t.text     "controller"
    t.text     "path"
    t.text     "uri"
    t.integer  "regular"
    t.string   "result"
    t.text     "content",    :limit => 2147483647
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"


  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sys_creators", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "group_id"
  end

  create_table "sys_editable_groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "group_ids"
  end

  create_table "sys_files", :force => true do |t|
    t.integer  "unid"
    t.string   "tmp_id"
    t.integer  "parent_unid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "title"
    t.text     "mime_type"
    t.integer  "size"
    t.integer  "image_is"
    t.integer  "image_width"
    t.integer  "image_height"
  end

  add_index "sys_files", ["parent_unid", "name"], :name => "parent_unid"

  create_table "sys_group_change_groups", :force => true do |t|
    t.integer "group_change_id"
    t.integer "group_id"
    t.integer "parent_id"
    t.integer "old_group_id"
  end

  create_table "sys_group_change_items", :force => true do |t|
    t.integer "item_id"
    t.integer "item_unid"
    t.integer "parent_item_id"
    t.string  "model"
    t.string  "owner_model"
  end

  add_index "sys_group_change_items", ["item_id", "model"], :name => "item_id"

  create_table "sys_group_change_logs", :force => true do |t|
    t.integer  "parent_id",                           :null => false
    t.string   "state",         :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_no",                            :null => false
    t.integer  "sort_no"
    t.string   "execute_state", :limit => 15
    t.datetime "executed_at"
    t.text     "title"
    t.text     "body",          :limit => 2147483647
  end

  create_table "sys_group_changes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "name"
    t.integer  "level_no"
    t.string   "parent_code"
    t.string   "parent_name"
    t.string   "change_division"
    t.integer  "ldap",             :null => false
    t.datetime "start_date"
    t.string   "old_division"
    t.integer  "old_id"
    t.string   "old_code"
    t.string   "old_name"
    t.string   "commutation_code"
  end

  create_table "sys_groups", :force => true do |t|
    t.string   "state",        :limit => 15
    t.string   "web_state",    :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id",                  :null => false
    t.integer  "level_no"
    t.string   "code",                       :null => false
    t.integer  "sort_no"
    t.integer  "layout_id"
    t.integer  "ldap",                       :null => false
    t.string   "ldap_version"
    t.string   "name"
    t.string   "name_en"
    t.string   "group_s_name"
    t.string   "tel"
    t.string   "outline_uri"
    t.text     "email"
  end

  create_table "sys_languages", :force => true do |t|
    t.string   "state",      :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_no"
    t.string   "name"
    t.text     "title"
  end

  create_table "sys_ldap_synchros", :force => true do |t|
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "version",    :limit => 10
    t.string   "entry_type", :limit => 15
    t.string   "code"
    t.integer  "sort_no"
    t.string   "name"
    t.string   "name_en"
    t.string   "email"
    t.string   "kana"
  end

  add_index "sys_ldap_synchros", ["version", "parent_id", "entry_type"], :name => "version"

  create_table "sys_maintenances", :force => true do |t|
    t.integer  "unid"
    t.string   "state",        :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.text     "title"
    t.text     "body"
  end

  create_table "sys_messages", :force => true do |t|
    t.integer  "unid"
    t.string   "state",        :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.text     "title"
    t.text     "body"
  end

  create_table "sys_object_privileges", :force => true do |t|
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_unid"
    t.string   "action",     :limit => 15
  end

  add_index "sys_object_privileges", ["item_unid", "action"], :name => "item_unid"

  create_table "sys_publishers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "name"
    t.text     "published_path"
    t.text     "content_type"
    t.integer  "content_length"
  end

  create_table "sys_recognitions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "recognizer_ids"
    t.text     "info_xml"
  end

  add_index "sys_recognitions", ["user_id"], :name => "user_id"

  create_table "sys_role_names", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "title"
  end

  create_table "sys_sequences", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "version"
    t.integer  "value"
  end

  add_index "sys_sequences", ["name", "version"], :name => "name"

  create_table "sys_tasks", :force => true do |t|
    t.integer  "unid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "process_at"
    t.string   "name"
  end

  create_table "sys_unids", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model",      :null => false
    t.integer  "item_id"
  end

  create_table "sys_user_logins", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sys_user_logins", ["user_id"], :name => "user_id"

  create_table "sys_users", :force => true do |t|
    t.string   "air_login_id"
    t.string   "state",                     :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ldap",                                    :null => false
    t.string   "ldap_version"
    t.integer  "auth_no",                                 :null => false
    t.string   "name"
    t.text     "name_en"
    t.string   "account"
    t.text     "password"
    t.integer  "mobile_access"
    t.string   "mobile_password"
    t.text     "email"
    t.text     "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "kana"
    t.string   "sort_no"
    t.string   "official_position"
    t.string   "assigned_job"
  end

  create_table "sys_users_groups", :id => false, :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    :default => 0
    t.integer  "group_id"
  end

  add_index "sys_users_groups", ["user_id", "group_id"], :name => "user_id"

  create_table "sys_users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "sys_users_roles", ["user_id", "role_id"], :name => "user_id"

  create_table "video_admin_settings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "value"
    t.integer  "sort_no"
  end

  create_table "video_categories", :force => true do |t|
    t.integer  "unid"
    t.integer  "parent_id",                :null => false
    t.integer  "content_id"
    t.string   "state",      :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_no",                 :null => false
    t.integer  "sort_no"
    t.integer  "layout_id"
    t.string   "name"
    t.text     "title"
  end

  create_table "video_clip_originals", :force => true do |t|
    t.integer "clip_id"
    t.string  "name"
    t.text    "mime_type"
    t.string  "duration"
    t.integer "width"
    t.integer "height"
    t.integer "size"
    t.string  "extension"
    t.string  "bitrate"
    t.string  "audio_rate"
    t.string  "sampling_frequency"
  end

  add_index "video_clip_originals", ["clip_id"], :name => "clip_id"

  create_table "video_clips", :force => true do |t|
    t.integer  "unid"
    t.string   "state",              :limit => 15
    t.string   "agent_state",        :limit => 15
    t.string   "convert_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "published_year",     :limit => 4
    t.string   "published_month",    :limit => 2
    t.string   "published_day",      :limit => 2
    t.datetime "negated_at"
    t.integer  "skin_id"
    t.string   "main_category_id"
    t.string   "category_ids"
    t.string   "rel_clip_ids"
    t.text     "keywords",           :limit => 2147483647
    t.text     "recent_state"
    t.string   "name"
    t.text     "title"
    t.text     "body",               :limit => 2147483647
    t.text     "mime_type"
    t.string   "thumbnail_state",    :limit => 15
    t.float    "thumbnail_point"
    t.string   "duration"
    t.integer  "width"
    t.integer  "height"
    t.integer  "size"
    t.string   "extension"
    t.string   "bitrate"
    t.string   "audio_rate"
    t.string   "sampling_frequency"
    t.integer  "admin_is"
    t.integer  "creator_id"
    t.integer  "creator_group_id"
    t.text     "editting_state"
    t.text     "editting_group_ids"
    t.integer  "negator_id"
    t.integer  "view_count"
    t.string   "check_digit"
  end

  add_index "video_clips", ["creator_group_id"], :name => "creator_group_id"
  add_index "video_clips", ["published_year", "published_month", "published_day"], :name => "published_year"

  create_table "video_daily_accesses", :force => true do |t|
    t.string  "content"
    t.integer "item_id"
    t.date    "accessed_at"
    t.integer "count"
    t.string  "path"
  end

  create_table "video_settings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "value"
    t.integer  "sort_no"
  end

  create_table "video_skins", :force => true do |t|
    t.integer  "unid"
    t.integer  "concept_id"
    t.string   "state",        :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.string   "name"
    t.text     "title"
    t.text     "mime_type"
    t.integer  "size"
    t.integer  "sort_no"
  end

  create_table "video_temp_files", :force => true do |t|
    t.string   "tmp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "convert_state"
    t.integer  "admin_is"
    t.string   "name"
    t.text     "title"
    t.text     "mime_type"
    t.string   "extension"
    t.integer  "image_is"
    t.string   "thumbnail_state",    :limit => 15
    t.float    "thumbnail_point"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "duration"
    t.string   "bitrate"
    t.string   "audio_rate"
    t.string   "sampling_frequency"
  end

end
