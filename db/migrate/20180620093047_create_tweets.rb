class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.text :body
      
      t.timestamps
    end

    add_reference(:tweets, :user, foreign_key: true)
  end
end
