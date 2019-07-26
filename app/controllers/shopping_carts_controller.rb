class ShoppingCartsController < ApplicationController
  before_action :find_order, except: :show
  before_action :extract_shopping_cart, except: :show
  before_action :find_or_create_product, only: :create
  skip_authorization_check

  def create
    quantity = params[:quantity].to_i || 1
    order_item = @shopping_cart.add(@product, @product.price, quantity)
    order_item.update(printer_id: params[:printer_id]) if params[:printer_id]
    order_item.update(order_id: @shopping_cart.order_id) if @shopping_cart.order_id
    @order.update(revenue: @shopping_cart.subtotal) if @shopping_cart.order_id
  end

  def clear
    @shopping_cart.clear
  end

  def show
    @shopping_cart = ShoppingCart.find_by(id: params[:id])
  end

  def destroy
    @product = params[:item_type].classify.constantize.find(params[:product_id])
    quantity = params[:quantity].to_i || 1
    @shopping_cart.remove(@product, quantity)
  end

  private

  def find_or_create_product
    if params[:body]
      return if params[:body].blank?

      @product = OtherOrderItem.create(body: params[:body], price: params[:price])
    else
      @product = params[:item_type].classify.constantize.find(params[:product_id])
    end
  end

  def find_order
    @order = Order.find(params[:order_id]) if params[:order_id].present?
  end

  def extract_shopping_cart
    if @order
      @shopping_cart = @order.shopping_cart
    else
      @shopping_cart_id = params[:shopping_cart_id].presence || session[:shopping_cart_id]
      @shopping_cart = ShoppingCart.find_by(id: @shopping_cart_id.presence) || ShoppingCart.create
      # Не получится ли, что менеджер существующий заказ переписывать будет при создании нового?
      session[:shopping_cart_id] = @shopping_cart.id
    end
  end
end
