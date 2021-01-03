# ワークスペース
# workspace1 = Workspace.create!(name: 'ワークスペース1', image_url: 'sample1.jpg')
# workspace2 = Workspace.create!(name: 'ワークスペース2', image_url: 'sample2.jpg')
users = (1..5).map do |i|
  User.create!(
    email: "test#{i}@example.com",
    last_name: "hoge",
    first_name: "ユーザ#{i}",
    password: "Password1234!"
  )
end

(1..2).each do |i|
  # ワークスペース
  workspace = Workspace.create!(name: "ワークスペース#{i}", image_url: "sample#{i}.jpg")

  # ユーザ
  (1..4).each do |j|
    # ワークスペースに所属するユーザ
    WorkspaceUser.create!(
      user_id: users[j].id,
      workspace_id: workspace.id
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

    Task.create!(
      workspace_id: workspace.id,
      name: "タスク#{i}",
      detail: "詳細#{i}",
      priority: 1,
      status: status,
      due_date: "2019/3/#{10 + i}",
      display_order: display_order
    )
  end
end
