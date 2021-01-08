class RemoveUniqueFromAddIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :visits, name: "index_visits_on_short_url_id"
    remove_index :visits, name: "index_visits_on_visitor_id"
    remove_index :shortened_urls, name: "index_shortened_urls_on_user_id"

    add_index :visits, :short_url_id
    add_index :visits, :visitor_id
    add_index :shortened_urls, :user_id
  end
end
