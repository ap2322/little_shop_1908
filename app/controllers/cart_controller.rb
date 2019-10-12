class CartController < ApplicationController

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
end
