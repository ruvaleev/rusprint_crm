class AddOrderReferenceToShoppingCarts < ActiveRecord::Migration[5.1]
  def change
    add_reference :shopping_carts, :order, foreign_key: true
  end
end
