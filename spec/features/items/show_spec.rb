require 'rails_helper'

RSpec.describe 'item show page', type: :feature do
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

  it 'shows item info' do
    visit "/items/#{@chain.id}"

    expect(page).to have_link(@chain.merchant.name)
    expect(page).to have_content(@chain.name)
    expect(page).to have_content(@chain.description)
    expect(page).to have_content("Price: $#{@chain.price}")
    expect(page).to have_content("Active")
    expect(page).to have_content("Inventory: #{@chain.inventory}")
    expect(page).to have_content("Sold by: #{@bike_shop.name}")
    expect(page).to have_css("img[src*='#{@chain.image}']")
  end

  it "shows reviews for an item" do
    visit "/items/#{@chain.id}"
    reviews = [@review_1, @review_2]
    reviews.each do |review|
      within "#review-#{review.id}" do
        expect(page).to have_content(review.title)
        expect(page).to have_content(review.content)
        expect(page).to have_content(review.rating)
      end
    end
  end

  it 'has item name link' do
    visit "/merchants/#{@bike_shop.id}/items"
    click_link "Chain"

    expect(current_path).to eq("/items/#{@chain.id}")

    visit "/items"
    click_link "Chain"

    expect(current_path).to eq("/items/#{@chain.id}")
  end

  it "has an area for statistics about reviews
      the top three reviews for this item (title and rating only)
      the bottom three reviews for this item  (title and rating only)
      the average rating of all reviews for this item" do

    visit "/items/#{@chain.id}"

    within "#review-stats" do
      within "#top-reviews" do

        expect(page).to have_content("Title: #{@review_3.title}")
        expect(page).to have_content("Rating: #{@review_3.rating}")
        expect(page).to have_content("Title: #{@review_6.title}")
        expect(page).to have_content("Rating: #{@review_6.rating}")
        expect(page).to have_content("Title: #{@review_7.title}")
        expect(page).to have_content("Rating: #{@review_7.rating}")
      end
      within "#bottom-reviews" do

        expect(page).to have_content("Title: #{@review_1.title}")
        expect(page).to have_content("Rating: #{@review_1.rating}")
        expect(page).to have_content("Title: #{@review_2.title}")
        expect(page).to have_content("Rating: #{@review_2.rating}")
        expect(page).to have_content("Title: #{@review_4.title}")
        expect(page).to have_content("Rating: #{@review_4.rating}")
      end
      within "#average-rating" do

        expect(page).to have_content("Average Rating: 2.43")
      end
    end
  end

  it "has links to sort an item's reviews" do
    visit "/items/#{@chain.id}"

    within ".review-show-grid" do
      click_link "Sort by highest rating"
    end

    expect(page.find_all('.review')[0]).to have_content("This was great")
  end
end

# As a visitor,
# When I visit an item's show page to see their reviews,
# I see additional links to sort their reviews in the following ways:
# - sort reviews by highest rating, then by descending date
# - sort reviews by lowest rating, then by ascending date
