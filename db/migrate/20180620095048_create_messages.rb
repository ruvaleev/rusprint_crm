class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :author, foreign_key: {to_table: :users}
      t.references :recipient, foreign_key: {to_table: :users}

      t.timestamps
    end

  end
end
