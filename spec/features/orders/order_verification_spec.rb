require 'rails_helper'

describe "With an order verification" do
  it "can find an order by the verification number" do
    bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    shifter = bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    order = Order.create(name: "Rambo", address: "234 Broadway", city: "Denver", state: "CO", zip: "84309")
    item_order_1 = ItemOrder.create(item_id: chain.id, order_id: order.id, item_price: chain.price, item_quantity: 2)
    item_order_2 = ItemOrder.create(item_id: shifter.id, order_id: order.id, item_price: shifter.price, item_quantity: 1)

    order.update(verif: "1234578022")

    visit '/merchants'

    within 'nav' do
      fill_in :order_verif, with: "1234578022"
      click_button 'Search'
    end

    expect(current_path).to eq '/verified_order'
    expect(page).to have_content order.name
    expect(page).to have_content order.address
    expect(page).to have_content order.city
    expect(page).to have_content order.state
    expect(page).to have_content order.zip
    expect(page).to have_content chain.name
    expect(page).to have_content shifter.name

    expect(page).to have_link "Delete Order"
    expect(page).to have_link "Update Shipping Address"
    expect(page).to have_link "Remove Items"

#     If an order is found, I am redirected to a verified order page ('/verified_order')
# On that verified order page, I can:
# - click a link to delete the order
# - update the shipping address for an order
# - remove items from the order


  end
end
