require_relative "../pages/base"

module PageObjects
  module Course
    class New < Base
      def create(title, description)
        fill_form :course, title: title, description: description
        click_on 'Submit'
      end
    end
  end
end