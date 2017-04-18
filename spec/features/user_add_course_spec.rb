require 'rails_helper'

RSpec.feature "User add course" do
  describe "user create course" do
    before do
      User.create(email: 'test@example.com', password: '111111')
    end
    
    context 'valid information' do
      scenario "save the course" do
        course = build_stubbed(:course)
        course_form.create(course.title, course.description)
        expect(page).to have_content course.title
      end
    end
    
    context 'invalid information' do
      scenario "doesn't save the course" do
        course = build_stubbed(:course)
        course_form.create("", course.description)
        expect(page).to have_content t("courses.new.add_course")
      end
    end
  end
  
  private
    
    def course_form
      log_in.sign_in  'test@example.com', '111111'
      home_page.add_course
    end
    
    def log_in
      home_page.go
      navbar.sign_in
    end
    
    def navbar
      PageObjects::Application::Navbar.new
    end
    
    def home_page
      PageObjects::Pages::Home.new
    end
end