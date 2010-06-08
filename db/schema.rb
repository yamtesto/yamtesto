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

ActiveRecord::Schema.define(:version => 20100608074706) do

  create_table "jobs", :force => true do |t|
    t.string   "company"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "job_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.boolean  "activated"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "birth_date"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end