class AddSlugToTwitterUsers < ActiveRecord::Migration
  def change
    change_table :twitter_users do |t|
      t.string :slug, index: true
    end 
  end
end
