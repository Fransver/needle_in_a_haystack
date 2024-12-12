class CreateHaystackTags < ActiveRecord::Migration[7.2]
  def change
    create_table(:haystack_tags) do |t|
      t.string(:name, null: false)
      t.string(:description)
      t.string(:haystack_marker)
      t.references(:parent_tag, foreign_key: { to_table: :haystack_tags })
      t.timestamps
    end

    create_table(:haystack_taggings) do |t|
      t.references(:haystack_tag, foreign_key: true)
      t.references(:taggable, polymorphic: true, index: { name: "index_haystack_taggings_on_taggable" })
      t.timestamps
    end
  end
end
