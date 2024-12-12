# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# The `widgets` table is a dummy taggable used only by the test suite; it has no
# migration and is not shipped with the gem.

ActiveRecord::Schema[7.1].define(version: 2024_10_16_115811) do
  create_table "haystack_tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "haystack_marker"
    t.bigint "parent_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_tag_id"], name: "index_haystack_tags_on_parent_tag_id"
  end

  create_table "haystack_taggings", force: :cascade do |t|
    t.bigint "haystack_tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["haystack_tag_id"], name: "index_haystack_taggings_on_haystack_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_haystack_taggings_on_taggable"
  end

  create_table "widgets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "haystack_taggings", "haystack_tags"
  add_foreign_key "haystack_tags", "haystack_tags", column: "parent_tag_id"
end
