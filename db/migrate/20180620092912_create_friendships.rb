class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|

    end

    add_reference(:friendships, :first_friend, foreign_key: {to_table: :users})
    add_reference(:friendships, :second_friend, foreign_key: {to_table: :users})
  end
end
