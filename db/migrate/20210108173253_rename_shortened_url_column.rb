class RenameShortenedUrlColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :visits, :short_url_id, :shortened_url_id
  end
end
