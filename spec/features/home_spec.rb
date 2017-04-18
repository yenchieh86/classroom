require 'rails_helper'

RSpec.feature "Home" do
  scenario "welcome user" do
    home_page.go
    expect(page).to have_text "Welcome"
  end
  
  scenario "has navbar element" do
    home_page.go
    expect(page).to have_css "nav.navbar"
  end
  
  def home_page
    PageObjects::Pages::Home.new
  end
  
end