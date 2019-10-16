require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"
      expect(page).to have_link("All #{@bike_shop.name}'s Items")

      click_on "All #{@bike_shop.name}'s Items"
      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it "has merchant name link" do
      visit "/merchants"
      click_link "Brian's Bike Shop"
      expect(current_path).to eq("/merchants/#{@bike_shop.id}")

      visit "/items"
      click_link "Brian's Bike Shop"
      expect(current_path).to eq("/merchants/#{@bike_shop.id}")

      visit "/merchants/#{@bike_shop.id}/items"
      click_link("Brian's Bike Shop", match: :first)
      expect(current_path).to eq("/merchants/#{@bike_shop.id}")

      visit "/items/#{@chain.id}"
      click_link "Brian's Bike Shop"
      expect(current_path).to eq("/merchants/#{@bike_shop.id}")
    end

    it "has statistics of merchant" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      order = Order.create(name: "Rambo", address: "234 Broadway", city: "Denver", state: "CO", zip: "84309")
      item_order = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)
      order_2 = Order.create(name: "Yomama", address: "3423 Broadway", city: "Aurora", state: "CO", zip: "84409")
      item_order_2 = ItemOrder.create(item_id: chain.id, order_id: order_2.id, item_price: chain.price, item_quantity: 2)

      visit "/merchants/#{meg.id}"

      expect(page).to have_content("Total Items for #{meg.name}: 3")
      expect(page).to have_content("Average Price of #{meg.name}'s Items: $110.00")
      expect(page).to have_content("Aurora")
      expect(page).to have_content("Denver")
    end

    it "displays top three highest rated items for that merchant by average rating" do
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

      visit "/merchants/#{meg.id}"

      expect(page).to have_content(helmet.name)
      expect(page).to have_css("img[src*='#{helmet.image}']")
      expect(page).to have_content("Average Rating: 4.67")
      expect(page).to have_content(shifter.name)
      expect(page).to have_css("img[src*='#{shifter.image}']")
      expect(page).to have_content("Average Rating: 3.67")
      expect(page).to have_content(chain.name)
      expect(page).to have_css("img[src*='#{chain.image}']")
      expect(page).to have_content("Average Rating: 2.33")
      expect(page).to_not have_content(tire.name)
    end
  end
end
