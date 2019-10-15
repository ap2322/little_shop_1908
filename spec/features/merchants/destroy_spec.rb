require 'rails_helper'

RSpec.describe "As a visitor" do
  before (:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
  end

  describe "When I visit a merchant show page" do
    it "I can delete a merchant" do
      visit "merchants/#{@bike_shop.id}"
      click_on "Delete Merchant"

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_content("Brian's Bike Shop")
    end

    it "I can delete a merchant that has items" do
      visit "merchants/#{@bike_shop.id}"

      click_on "Delete Merchant"

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_content("Brian's Bike Shop")
    end
  end

  describe "if a merchant has items that have been ordered" do
    it "I cannot delete that merchant" do
      order = Order.create(name: "Rambo", address: "234 Broadway", city: "Denver", state: "CO", zip: "84309")
      item_order = ItemOrder.create(item_id: @chain.id, order_id: order.id, item_price: @chain.price, item_quantity: 2)

      visit "/merchants/#{@bike_shop.id}"

      expect(page).to_not have_button("Delete Merchant")
    end
  end

  describe "if a merchant has items that have not been ordered" do
    it "I can delete that merchant and all their items are deleted as well" do
      review_1 = @chain.reviews.create(title: "This stunk", content: "super smelly", rating: 1)

      visit "/merchants/#{@bike_shop.id}"
      click_on "Delete Merchant"

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_content("Brian's Bike Shop")

      visit "/items"

      expect(page).to_not have_content("Chain")
    end
  end
end
