class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.string :body
      t.references :user
      t.references :registerable, polymorphic: true
      t.string :registerable_type
    end
  end
end
