class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :object_id
      t.string :object_type
      t.integer :user_id
      t.index :object_id
      t.index :user_id
      t.integer :value

      t.timestamps
    end
  end
end
