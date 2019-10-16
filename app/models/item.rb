class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, :dependent => :destroy
  has_many :item_orders, :dependent => :destroy
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]

  def top_three_reviews
    # later challenge, combine top and bottom 3 reviews in one method by taking in a parameter
    reviews.order(rating: :desc).limit(3)
  end

  def bottom_three_reviews
    reviews.order(:rating).limit(3)
  end

  def average_rating
    reviews.average(:rating).to_f.round(2)
  end

  def in_order?
    !item_orders.all.empty?
  end

  def sort_review_by_rating
    reviews.order(rating: :desc).order(created_at: :desc)
  end
end
