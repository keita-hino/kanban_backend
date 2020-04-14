# ユーザ
(1..5).each do |i|
  User.create(
    email: "test#{i}@example.com",
    last_name: "hoge",
    first_name: "ユーザ#{i}",
    password: "Password1234!"
  )
end

# タスク
10.times do |i|
  status = 1
  if i > 3 && i <= 6
    status = 2
  elsif i >= 7
    status = 3
  end

  display_order = Task.where(status: status).count + 1

  Task.create(
    name: "タスク#{i}",
    detail: "詳細#{i}",
    priority: 1,
    status: status,
    due_date: "2019/3/#{10 + i}",
    display_order: display_order
  )
end
