class AddCompaniesRefToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :employer, foreign_key: { to_table: :companies } 
  end
end
