require 'spec_helper'

describe "Static Pages" do
  let(:base_title) {"2witters"}
  describe "Home page" do
    it "Should have the content '2witters App'" do
      visit '/static_pages/home'
      expect(page).to have_content('2witters App')
    end
    it "Should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{base_title} | Home")
    end
  end

  describe "Help page" do
    it "Should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
    end
    it "Should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
  end

  describe "About page" do
    it "Should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About")
    end
    it "Should have the content 'About'" do
      visit '/static_pages/about'
      expect(page).to have_content("About")
    end
  end

  describe "Contact page" do
    it "Should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title} | Contact")
    end
    it "Should have the content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end
  end
end
