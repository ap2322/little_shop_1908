class MerchantsController <ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      redirect_to "/merchants"
    else
      flash.now[:merchant_create_error] = "Merchant not created, please fill in all fields"
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    if merchant.save
      redirect_to "/merchants/#{merchant.id}"
    else
      flash.now[:merchant_update_error] = "Merchant not updated, please fill in all fields"
      @merchant = Merchant.find(params[:id])
      render :edit
    end
  end

  def destroy
    Merchant.destroy(params[:id])
    redirect_to '/merchants'
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end
end
