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

ActiveRecord::Schema.define(:version => 20130715214941) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "api_key"
    t.string   "coupon"
    t.string   "stripe_token"
    t.string   "customer_id"
    t.integer  "last_4_digits"
    t.integer  "plan_id"
  end

  create_table "accounts_roles", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "role_id"
  end

  add_index "accounts_roles", ["account_id", "role_id"], :name => "index_accounts_roles_on_account_id_and_role_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "alerts", :force => true do |t|
    t.integer  "date"
    t.string   "alert_type"
    t.text     "des"
    t.boolean  "processed"
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bigcommerce_accounts", :force => true do |t|
    t.string   "store_url"
    t.string   "username"
    t.string   "api_key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "slug"
    t.boolean  "processed"
  end

  add_index "bigcommerce_accounts", ["slug"], :name => "index_bigcommerce_accounts_on_slug", :unique => true

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "brandid"
    t.integer  "account_id"
    t.string   "page_title"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "image_file"
    t.string   "search_keywords"
  end

  create_table "categories", :force => true do |t|
    t.string  "categoryid"
    t.integer "account_id"
    t.integer "parent_id"
    t.string  "name"
    t.string  "description"
    t.string  "page_title"
    t.string  "image_file"
    t.string  "image_tag"
    t.string  "url"
    t.boolean "has_child"
    t.integer "product_count"
    t.integer "product_sub_count"
  end

  add_index "categories", ["account_id"], :name => "index_categories_on_account_id"
  add_index "categories", ["categoryid"], :name => "index_categories_on_categoryid"

  create_table "category_products", :force => true do |t|
    t.integer  "account_id"
    t.integer  "productid"
    t.integer  "categoryid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "images", :force => true do |t|
    t.integer "imageid"
    t.integer "account_id"
    t.integer "productid"
    t.string  "image_file"
    t.string  "description"
  end

  add_index "images", ["account_id"], :name => "index_images_on_account_id"
  add_index "images", ["productid"], :name => "index_images_on_productid"

  create_table "include_options", :force => true do |t|
    t.integer  "include_id"
    t.integer  "option_id"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "include_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "des"
    t.boolean  "des_instead_of_name"
  end

  create_table "includes", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "brand_id"
    t.integer  "include_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
    t.string   "api_key"
    t.string   "include_file"
    t.integer  "account_id"
  end

  create_table "option_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "options", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "include_type_id"
    t.string   "title"
    t.text     "des"
    t.integer  "option_type_id"
    t.boolean  "show_in_index"
  end

  create_table "plans", :force => true do |t|
    t.integer  "includes"
    t.integer  "impressions"
    t.boolean  "api_shortcodes"
    t.boolean  "html_uploads"
    t.boolean  "advanced_logic"
    t.string   "support"
    t.float    "price"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "name"
    t.string   "api_name"
  end

  create_table "products", :force => true do |t|
    t.integer  "productid"
    t.string   "name"
    t.string   "type"
    t.string   "sku"
    t.string   "description"
    t.string   "availability"
    t.string   "availability_description"
    t.string   "price"
    t.string   "cost_price"
    t.string   "retail_price"
    t.string   "sale_price"
    t.string   "calculated_price"
    t.string   "inventory_level"
    t.string   "warranty"
    t.string   "weight"
    t.string   "width"
    t.string   "height"
    t.string   "depth"
    t.string   "total_sold"
    t.string   "date_created"
    t.string   "brand_id"
    t.string   "view_count"
    t.string   "page_title"
    t.string   "date_modified"
    t.string   "condition"
    t.string   "upc"
    t.string   "custom_url"
    t.integer  "account_id"
    t.boolean  "processed"
    t.datetime "updated_at"
  end

  add_index "products", ["account_id"], :name => "index_products_on_account_id"
  add_index "products", ["productid"], :name => "index_products_on_productid"

  create_table "rich_rich_files", :force => true do |t|
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        :default => "file"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "statistics", :force => true do |t|
    t.integer  "include_id"
    t.integer  "date"
    t.integer  "views"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "customer_id"
    t.string   "last_4_digits"
    t.string   "api_key"
    t.integer  "account_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
