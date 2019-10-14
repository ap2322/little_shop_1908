require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant }
    it {should have_many(:reviews).dependent(:destroy) }
    it {should have_many(:item_orders).dependent(:destroy) }
    it {should have_many(:orders).through(:item_orders)}

  end

  describe "methods" do
    before (:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "This stunk", content: "super smelly", rating: 1)
      @review_2 = @chain.reviews.create(title: "This blew my mind", content: "goddawful", rating: 1)
      @review_3 = @chain.reviews.create(title: "This was great", content: "It worked just as described", rating: 5)
      @review_4 = @chain.reviews.create(title: "This was terrible", content: "Broke within the first week", rating: 1)
      @review_5 = @chain.reviews.create(title: "Meh", content: "Nothing special", rating: 2)
      @review_6 = @chain.reviews.create(title: "Just ok", content: "Worked but not blown away", rating: 3)
      @review_7 = @chain.reviews.create(title: "Chain Chain Chain", content: "Chain a fool!", rating: 4)
    end

    it "can return the top three reviews for an item" do
      expect(@chain.top_three_reviews).to include(@review_3)
      expect(@chain.top_three_reviews).to include(@review_7)
      expect(@chain.top_three_reviews).to include(@review_6)
    end

    it "can return the bottom three reviews for an item" do
      expect(@chain.bottom_three_reviews).to include(@review_1)
      expect(@chain.bottom_three_reviews).to include(@review_2)
      expect(@chain.bottom_three_reviews).to include(@review_4)
    end

    it "can return the average rating of an item" do
      expect(@chain.average_rating).to eq(2.43)
    end
  end
end
