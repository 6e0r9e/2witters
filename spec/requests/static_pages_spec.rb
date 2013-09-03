require 'spec_helper'

describe "Static Pages" do
  describe "Home page" do
    it "Should have the content '2witters App'" do
      visit '/static_pages/home'
      expect(page).to have_content('2witters App')
    end
  end

  describe "Help page" do
    it "Should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
  end

  describe "About page" do
    it "Should have the content 'About'" do
      visit '/static_pages/about'
      expect(page).to have_content("About")
    end
  end
end
