
# 10.times do |i|
#   User.create(name: "user#{i}", age: i)
# end

10.times do |i|
  Task.create(
    name: "タスク#{i}",
    status: 1,
    start_date: "2019/3/#{1 + i}",
    due_date: "2019/3/#{10 + i}",
    display_order: 1 + i
  )
end