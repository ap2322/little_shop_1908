require 'rails_helper'

RSpec.describe 'merchant new page', type: :feature do
  describe 'As a user' do
    before(:each) do
      @name = "Sal's Calz(ones)"
      @address = '123 Kindalikeapizza Dr.'
      @city = "Denver"
      @state = "CO"
      @zip = 80204
    end
    it 'I can create a new merchant' do
      visit '/merchants/new'

      fill_in :name, with: @name
      fill_in :address, with: @address
      fill_in :city, with: @city
      fill_in :state, with: @state
      fill_in :zip, with: @zip

      click_button "Create Merchant"

      new_merchant = Merchant.last

      expect(current_path).to eq('/merchants')
      expect(page).to have_content(@name)
      expect(new_merchant.name).to eq(@name)
      expect(new_merchant.address).to eq(@address)
      expect(new_merchant.city).to eq(@city)
      expect(new_merchant.state).to eq(@state)
      expect(new_merchant.zip).to eq(@zip)
    end

    it "doesn't create a new merchant and shows flash message with incomplete information" do
      visit '/merchants/new'

      fill_in :name, with: @name
      fill_in :address, with: @address
      fill_in :state, with: @state
      fill_in :zip, with: @zip

      click_button "Create Merchant"

      expect(page).to have_content("Merchant not created, please fill in all fields")
      expect(page).to have_content("Create Merchant")
    end
  end
end
