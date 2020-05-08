FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    last_name { 'hoge' }
    first_name { 'ユーザ' }
    password { 'Password1234!' }
  end
end