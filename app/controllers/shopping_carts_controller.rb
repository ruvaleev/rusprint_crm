class ShoppingCartsController < ApplicationController
  before_action :extract_shopping_cart
  skip_authorization_check

  def create
    if params[:body]
      return if params[:body].blank?

      @product = OtherOrderItem.create(body: params[:body], price: params[:price])
    else
      @product = params[:item_type].classify.constantize.find(params[:product_id])
    end
    quantity = params[:quantity].to_i || 1
    @shopping_cart.add(@product, @product.price, quantity)
  end

  def clear
    @shopping_cart.clear
  end

  def destroy
    @product = params[:item_type].classify.constantize.find(params[:product_id])
    quantity = params[:quantity].to_i || 1
    @shopping_cart.remove(@product, quantity)
  end

  private

  def extract_shopping_cart
    shopping_cart_id = session[:shopping_cart_id]
    @shopping_cart = if session[:shopping_cart_id]
                       ShoppingCart.find_by(id: shopping_cart_id) || ShoppingCart.create
                     else
                       ShoppingCart.create
                     end
    session[:shopping_cart_id] = @shopping_cart.id
  end
end
