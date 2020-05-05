FactoryBot.define do
  factory :task do
    association :workspace
    name { 'task' }
    detail { 'detail' }
    status { 'unstarted' }
    priority { 'low' }
    display_order { 1 }
    due_date { Time.now }
  end
end