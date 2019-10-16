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

  def top_items
    # All in ruby, need to find Active Record way to do the same thing!
    avg_ratings = {}
    items.each do |item|
      key = item.id
      avg_ratings[key] = item.average_rating
    end
    sorted = avg_ratings.sort_by{|item_id, rating| rating}.reverse
    top_3 = sorted.map {|item_id, rating| items.find(item_id)}
    top_3[0..2]
  end
end
