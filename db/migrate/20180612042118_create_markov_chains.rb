class CreateMarkovChains < ActiveRecord::Migration
  def change
    create_table :markov_chains do |t|
      t.references :twitter_user, index: true

      t.timestamps null: false
    end
    add_foreign_key :markov_chains, :twitter_users
  end
end
