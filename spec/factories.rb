FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  
  factory :user do
    email
    password "111111"
    password_confirmation "111111"
  end
  
  factory :course do
    title "Course Name"
    description "Description."
    user
  end
end