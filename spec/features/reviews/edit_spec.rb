require 'rails_helper'

RSpec.describe "Edit a Review" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @review_1 = @chain.reviews.create(title: "This stunk", content: "super smelly", rating: 1)
  end

  describe "On an item's show page" do
    it "I can click a link to edit a review via form" do
      visit "/items/#{@chain.id}"

      click_link "Edit Review"

      expect(current_path).to eq("/items/#{@chain.id}/reviews/#{@review_1.id}/edit")

      fill_in 'Title', with: "Amaaaazing"
      fill_in 'Rating', with: 5
      fill_in 'Content', with: "The best chain in the history of chains"

      click_button "Update Review"

      expect(current_path).to eq("/items/#{@chain.id}")
      expect(page).to have_content("Amaaaazing")
      expect(page).to have_content("Rating: 5")
      expect(page).to have_content("The best chain in the history of chains")
    end
  end

  describe "with incomplete review edit form" do
    it "shows a flash message" do
      visit "/items/#{@chain.id}/reviews/#{@review_1.id}/edit"

      fill_in :title, with: "Cool chain dude."
      fill_in :content, with: "Off the chain."

      click_button "Update Review"

      expect(page).to have_content("Review not updated. Please fill in all fields.")
      expect(page).to have_button("Update Review")
    end
  end
end
