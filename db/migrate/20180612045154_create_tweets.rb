class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :body
      t.references :twitter_user, index: true

      t.timestamps null: false
    end
    add_foreign_key :tweets, :twitter_users
  end
end
