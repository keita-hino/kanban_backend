FactoryBot.define do
  factory :task do
    association :workspace
    name { 'task' }
    detail { 'detail' }
    status { 'unstarted' }
    priority { 'low' }
    sequence(:display_order) { |n| n + 1 }
    due_date { Time.now }
  end
end