require 'rails_helper'

RSpec.describe "delete review" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @review_1 = @chain.reviews.create(title: "This stunk", content: "super smelly", rating: 1)
  end
  
  it "I can click a link to delete the review" do
    visit "/items/#{@chain.id}"

    within "#review-#{@review_1.id}" do
      click_link "Delete Review"
    end

    expect(current_path).to eq("/items/#{@chain.id}")
    expect(page).to_not have_content(@review_1.title)
    expect(page).to_not have_content(@review_1.content)
    expect(page).to_not have_content("Rating: #{@review_1.rating}")
  end
end
