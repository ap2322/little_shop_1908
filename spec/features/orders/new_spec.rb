require 'rails_helper'

RSpec.describe "On the Checkout Page (aka New Order page)" do
  describe "details of the cart are on the page" do
    it "and it has a form to make a new order with
        - name
        - address
        - city
        - state
        -zip" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      visit "/items/#{chain.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"

      visit '/orders/new'
      within "#item-#{chain.id}" do
        expect(page).to have_content(chain.name)
        expect(page).to have_content(chain.merchant.name)
        expect(page).to have_content(chain.price)
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $50.00")
      end
      within "#item-#{shifter.id}" do
        expect(page).to have_content(shifter.name)
        expect(page).to have_content(shifter.merchant.name)
        expect(page).to have_content(shifter.price)
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: $360.00")
      end

      expect(page).to have_content("Grand Total: $410.00")

      fill_in :name, with: "Bob G"
      fill_in :address, with: "5555 Neverwhere Ln"
      fill_in :city, with: "Loveland"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80004"

      click_button "Create Order"
    end
  end

  describe "when user fills out order form" do
    it "creates a new order" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      visit "/items/#{chain.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"

      visit '/orders/new'

      fill_in :name, with: "Bob G"
      fill_in :address, with: "5555 Neverwhere Ln"
      fill_in :city, with: "Loveland"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80004"

      click_button "Create Order"

      order = Order.last

      expect(current_path).to eq "/orders/#{order.id}"
      expect(page).to have_content("Bob G")
      expect(page).to have_content("5555 Neverwhere Ln")
      expect(page).to have_content("Loveland")
      expect(page).to have_content("CO")
      expect(page).to have_content("80004")

      expect(page).to have_content(chain.name)
      expect(page).to have_content(chain.merchant.name)
      expect(page).to have_content(chain.price)
      expect(page).to have_content("Quantity: 1")
      expect(page).to have_content("Subtotal: $50.00")

      expect(page).to have_content(shifter.name)
      expect(page).to have_content(shifter.merchant.name)
      expect(page).to have_content(shifter.price)
      expect(page).to have_content("Quantity: 2")
      expect(page).to have_content("Subtotal: $360.00")

      expect(page).to have_content("Grand Total: $410.00")

      date_actual = order.created_at.strftime("%D")
      expect(page).to have_content("Date of Order: #{date_actual}")

    end
  end

  describe "when I click Create Order without filling in all fields" do
    it "has a flash message for an incomplete form" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      visit "/items/#{chain.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"

      visit '/orders/new'

      fill_in :name, with: "Bob G"
      fill_in :address, with: "5555 Neverwhere Ln"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80004"

      click_button "Create Order"

      expect(page).to have_content("Please fill in all fields to complete your order")
      expect(page).to have_button("Create Order")
    end
  end

  describe "When I make an order" do
    it "empties our cart" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      visit "/items/#{chain.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"
      visit "/items/#{shifter.id}"
      click_button "Add to Cart"

      visit '/orders/new'

      fill_in :name, with: "Bob G"
      fill_in :address, with: "5555 Neverwhere Ln"
      fill_in :city, with: "Loveland"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80004"

      click_button "Create Order"

      order = Order.last

      within "#cart" do
        expect(page).to have_content("0")
      end
    end
  end
end
