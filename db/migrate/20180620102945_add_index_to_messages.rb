class AddIndexToMessages < ActiveRecord::Migration[5.1]
  def change
    add_index :messages, [:author_id, :recipient_id]
  end
end
