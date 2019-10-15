class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = Item.new(item_params.merge(merchant_id: merchant.id))
    if item.save
      redirect_to "/merchants/#{merchant.id}/items"
    else
      flash.now[:errors] = item.errors.full_messages
      @merchant = Merchant.find(params[:merchant_id])
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      redirect_to "/items/#{item.id}"
    else
      flash.now[:errors] = item.errors.full_messages
      @item = Item.find(params[:id])
      render :edit
    end
  end

  def destroy
    Item.destroy(params[:id])
    redirect_to "/items"
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
