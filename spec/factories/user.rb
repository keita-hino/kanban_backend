FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    last_name { 'hoge' }
    first_name { 'ユーザ' }
    password { 'Password1234!' }
  end
end