require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many(:items).dependent(:destroy)}
  end

  describe "methods" do
    it "items_in_order? returns boolean if a merchant's items have been ordered" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      order = Order.create(name: "Rambo", address: "234 Broadway", city: "Denver", state: "CO", zip: "84309")
      item_order = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)

      actual = bike_shop.items_in_order?
      expect(actual).to eq(true)

      actual_2 = meg.items_in_order?
      expect(actual_2).to eq(false)
    end

    it "counts items for a merchant" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      order = Order.create(name: "Rambo", address: "234 Broadway", city: "Denver", state: "CO", zip: "84309")
      item_order = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)
      order_2 = Order.create(name: "Yomama", address: "3423 Broadway", city: "Aurora", state: "CO", zip: "84409")
      item_order_2 = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)

      expect(meg.count_items).to eq(3)
    end

    it "calculates average price of merchant items" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      order = Order.create(name: "Rambo", address: "234 Broadway", city: "Denver", state: "CO", zip: "84309")
      item_order = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)
      order_2 = Order.create(name: "Yomama", address: "3423 Broadway", city: "Aurora", state: "CO", zip: "84409")
      item_order_2 = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)

      expect(meg.average_item_price).to eq(110.00)
    end

    it "returns array of distinct cities where items are sold" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 7)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      order = Order.create(name: "Rambo", address: "234 Broadway", city: "Denver", state: "CO", zip: "84309")
      item_order = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)
      order_2 = Order.create(name: "Yomama", address: "3423 Broadway", city: "Aurora", state: "CO", zip: "84409")
      item_order_2 = ItemOrder.create(item_id: chain.id, order_id: order_2.id, item_price: chain.price, item_quantity: 2)
      order_3 = Order.create(name: "Nemo", address: "3423 Broadway", city: "Aurora", state: "CO", zip: "84409")
      item_order_3 = ItemOrder.create(item_id: chain.id, order_id: order_3.id, item_price: chain.price, item_quantity: 2)

      expect(meg.customer_cities).to eq(["Aurora", "Denver"])
    end

    it "calculates average rating of merchant items" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      helmet = meg.items.create(name: "Helmet", description: "It'll protect your noggin!", price: 40, image: "https://images-na.ssl-images-amazon.com/images/I/71kr1GfrR1L._SX466_.jpg", inventory: 5)

      tire_review_1 = tire.reviews.create(title: "Went flat", content: "super smelly", rating: 1)
      tire_review_2 = tire.reviews.create(title: "The road shredded these tires", content: "goddawful", rating: 1)
      tire_review_3 = tire.reviews.create(title: "Would not recommend", content: "Absolutely terrible", rating: 1)

      chain_review_1 = chain.reviews.create(title: "This stunk", content: "super smelly", rating: 1)
      chain_review_2 = chain.reviews.create(title: "This blew my mind", content: "goddawful", rating: 1)
      chain_review_3 = chain.reviews.create(title: "This was great", content: "It worked just as described", rating: 5)

      shifter_review_1 = shifter.reviews.create(title: "Not bad", content: "This was ok", rating: 3)
      shifter_review_2 = shifter.reviews.create(title: "It shifted as described", content: "No problems so far", rating: 4)
      shifter_review_3 = shifter.reviews.create(title: "Pretty good", content: "I'd recommend these to a friend", rating: 4)

      helmet_review_1 = helmet.reviews.create(title: "Great", content: "Protects my brain", rating: 4)
      helmet_review_2 = helmet.reviews.create(title: "Amazing", content: "Fell off my bike and I was fine", rating: 5)
      helmet_review_3 = helmet.reviews.create(title: "Wow!", content: "Like a shield for head", rating: 5)

      expected = [helmet, shifter, chain]
      expect(meg.top_items).to eq(expected)
    end
  end
end
