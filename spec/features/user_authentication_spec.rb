require 'rails_helper'

RSpec.feature "User authentication" do
  scenario "existing user signs in" do
    create(:user, email: "test@example.com", password: "111111")
    
    visit "/users/sign_in"
    
    within(".new_user") do
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "111111"
    end
    
    click_button "Log in"
    
    expect(page).to have_text "test@example.com"
  end
  
  scenario "user sign out" do
    create(:user, email: "test@example.com", password: "111111")
    
    visit "/users/sign_in"
    
    within(".new_user") do
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "111111"
    end
    
    click_button "Log in"
    
    click_link "Logout"
    
    expect(page).not_to have_text "test@example.com"
  end
  
  describe "user sign in", type: :feature do
    before :each do
      User.create(email: "test@example.com", password: "111111")
    end
    
    it "sign in the user" do
      new_session_page.sign_in "test@example.com", "111111"
      
      expect(page).to have_content "test@example.com"
    end
  end
  
  describe "user sign out", type: :feature do
    before :each do
      User.create(email: "test@example.com", password: "111111")
    end
    
    it "sign out the user" do
      new_session_page.sign_in "test@example.com", "111111"
      navbar.sign_out "test@example.com"
      
      expect(page).not_to have_content "test@example.com"
    end
  end
  
  feature "user can't sign in" do
    before do
      User.create(email: 'test@example.com', password: '111111')
    end
    
    scenario "wrong information" do
      new_session_page.sign_in "wrong@example.com", "111111"
      expect(page).not_to have_content "test@example.com"
    end
  end
  
  private
  
    def home_page
      PageObjects::Pages::Home.new
    end
  
    def new_session_page
      home_page.go
      navbar.sign_in
    end
  
    def navbar
      PageObjects::Application::Navbar.new
    end
end