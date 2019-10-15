class OrdersController < ApplicationController

  def new
    cart_contents = session[:cart] ||= {}
    @items = Item.where(id: cart_contents.keys)
  end

  def create
    order = Order.new(order_params)

    if order.save
      make_item_orders(order)
      session[:cart] = {}
      redirect_to "/orders/#{order.id}"
    else
      flash.now[:incomplete_order] = "Please fill in all fields to complete your order"
      @items = Item.where(id: session[:cart].keys)
      render :new
    end
  end

  def show
    @order = Order.find(params[:order_id])
  end

private
  def order_params
    params.permit(:name,:address,:city,:state,:zip)
  end

  def make_item_orders(order)
    session[:cart].each do |id, quantity|
      item = Item.find(id)
      order.item_orders.create(item_id: id, item_price: item.price, item_quantity: quantity)
    end
  end
end
