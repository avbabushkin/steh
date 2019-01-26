FactoryBot.define do 
  factory :user do
    name { "Examle User" }
    email { "example@railstutorial.org" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end