class RenameColumnInVisits < ActiveRecord::Migration[5.2]
  def change
    rename_column :visits, :visitor_id, :user_id
  end
end
