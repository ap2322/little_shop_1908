require 'rails_helper'

RSpec.describe "Across all pages" do
  it "has an indicator at the top showing a cart and the items in the cart" do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    visit '/merchants'

    within "#cart" do
      expect(page).to have_content("0")
    end

    visit "/items/#{@chain.id}"
    click_button "Add to Cart"

    within "#cart" do
      expect(page).to have_content("1")
    end

    visit "/items/#{@shifter.id}"
    click_button "Add to Cart"

    within "#cart" do
      expect(page).to have_content("2")
    end

    visit "/items/#{@chain.id}"
    click_button "Add to Cart"

    within "#cart" do
      expect(page).to have_content("3")
    end
  end
end

# As a visitor
# I see a cart indicator in my navigation bar
# The cart indicator shows a count of items in my cart
# I can see this cart indicator from any page in the application
