class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :name, unique: true, index: true

      t.timestamps null: false
    end
  end
end
