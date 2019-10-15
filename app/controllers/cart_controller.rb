class CartController < ApplicationController
  include ActionView::Helpers::TextHelper

  def update_cart
    item = Item.find(params[:item_id])
    cart.add_item(item.id)
    session[:cart] = cart.contents
    flash[:item_added] = "Item added to cart"

    redirect_to '/items'
  end

  def show
    cart_contents = session[:cart] ||= {}
    @items = Item.where(id: cart_contents.keys)
  end

  def empty
    cart.empty_cart
    session[:cart] = cart.contents

    redirect_to '/cart'
  end

  def remove_item
    cart.delete_item(params[:item_id])
    session[:cart] = cart.contents

    redirect_to '/cart'
  end

  def increment_item
    item = Item.find(params[:item_id])
    if item.inventory < (cart.count_of(item.id) + 1)
      flash.now[:cart_inventory_error] = "Only #{pluralize(item.inventory, item.name) } in stock"
    end
    cart.plus_one_item(params[:item_id])
    session[:cart] = cart.contents
    @items = Item.where(id: cart.contents.keys)
    render :show
  end

  def decrement_item
    cart.minus_one_item(params[:item_id])
    item = Item.find(params[:item_id])
    session[:cart] = cart.contents

    redirect_to '/cart'
  end
end
