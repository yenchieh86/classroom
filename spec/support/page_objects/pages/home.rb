require_relative 'base'

module PageObjects
  module Pages
    class Home < Base
      def go
        visit root_url
      end
      
      def add_course
        visit new_course_url
        add_course_form
      end
      
      private
      
        def add_course_form
          PageObjects::Course::New.new
        end
    end
  end
end