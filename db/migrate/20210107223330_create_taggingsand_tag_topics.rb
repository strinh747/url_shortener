class CreateTaggingsandTagTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :taggingsand_tag_topics do |t|
      t.string :name
      
      t.timestamps
    end

    rename_table :taggingsand_tag_topics, :tag_topics
  end
end
