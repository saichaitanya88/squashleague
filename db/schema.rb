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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131103190714) do

  create_table "awards", force: true do |t|
    t.string   "status"
    t.string   "award_name"
    t.string   "award_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "awards", ["award_name"], name: "index_awards_on_award_name", unique: true

  create_table "awards_to_players", force: true do |t|
    t.string   "status"
    t.integer  "award_id"
    t.integer  "player_id"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: true do |t|
    t.string   "division_level"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "status"
    t.integer  "player1_score"
    t.integer  "player2_score"
    t.integer  "game_winner_id"
    t.integer  "game_number"
    t.integer  "match_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "status"
    t.string   "image_type"
    t.string   "image_url"
    t.string   "image_alt"
    t.string   "image_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.string   "status"
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches_to_rounds", force: true do |t|
    t.integer  "match_id"
    t.integer  "round_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches_to_rounds", ["match_id"], name: "index_matches_to_rounds_on_match_id", unique: true
  add_index "matches_to_rounds", ["round_id"], name: "index_matches_to_rounds_on_round_id"

  create_table "players", force: true do |t|
    t.string   "status"
    t.string   "first_name",       null: false
    t.string   "last_name",        null: false
    t.string   "bio"
    t.integer  "primary_image_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players_to_seasons", force: true do |t|
    t.string   "status"
    t.string   "player_id"
    t.string   "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["level"], name: "index_roles_on_level", unique: true

  create_table "rounds", force: true do |t|
    t.string   "round_name"
    t.integer  "round_order"
    t.date     "round_start"
    t.date     "round_end"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds_to_seasons", force: true do |t|
    t.integer  "round_id"
    t.integer  "season_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.string   "season_name"
    t.integer  "season_winner"
    t.string   "season_status"
    t.date     "season_start"
    t.date     "season_end"
    t.integer  "matches_per_player_pair"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seasons", ["season_name"], name: "index_seasons_on_season_name", unique: true

  create_table "seasons_to_divisions", force: true do |t|
    t.integer  "division_id"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
