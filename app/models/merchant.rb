class Merchant <ApplicationRecord
  has_many :items, :dependent => :destroy

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def items_in_order?
    !items.joins(:item_orders).empty?
  end

  def count_items
    items.count(:items)
  end

  def average_item_price
    items.average(:price)
  end

  def customer_cities
    items.joins(:orders).select('orders.city').distinct.pluck('orders.city')
  end
end
