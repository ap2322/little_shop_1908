require 'rails_helper'

RSpec.describe "review create page" do
  describe "when I visit the item's show page" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @review_1 = @chain.reviews.create(title: "This stunk", content: "super smelly", rating: 1)
      @review_2 = @chain.reviews.create(title: "This blew my mind", content: "goddawful", rating: 1)
    end

    describe "I can click a link to create a review" do
      it "I can make a new review through a form" do
        visit "/items/#{@chain.id}"

        click_link "Review This Item"

        expect(current_path).to eq("/items/#{@chain.id}/reviews/new")

        fill_in :title, with: "Cool chain dude."
        fill_in :content, with: "Off the chain."
        fill_in :rating, with: 5

        click_button "Submit Review"

        expect(current_path).to eq("/items/#{@chain.id}")
        expect(page).to have_content("Cool chain dude.")
        expect(page).to have_content("Off the chain.")
      end
    end

    describe "with incomplete review" do
      it "shows a flash message" do
        visit "/items/#{@chain.id}/reviews/new"

        fill_in :title, with: "Cool chain dude."
        fill_in :content, with: "Off the chain."

        click_button "Submit Review"

        expect(page).to have_content("Review not created. Please fill in all fields")
        expect(page).to have_button("Submit Review")
      end
    end
  end
end
