class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.integer :short_url_id
      t.integer :visitor_id
      
      t.timestamps
    end

    add_index :visits, :short_url_id, unique:true
    add_index :visits, :visitor_id, unique:true 
  end


end
