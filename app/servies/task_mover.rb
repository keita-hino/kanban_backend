class TaskMover
  # 初期化
  def initialize(workspace_id, moved_tasks_params)
    @workspace_id = workspace_id
    @moved_tasks_params = moved_tasks_params
  end

  # タスクの並び順を変更
  def move
    # 挿入されたタスク直下のタスク
    before_moved_task = Task.status_is(@moved_tasks_params[:status])
                            .display_order_is(@moved_tasks_params[:display_order])
                            .workspace_id_is(@workspace_id)
                            .order(:display_order)
                            .last

    # タスクステータス更新処理
    task = Task.find(@moved_tasks_params[:id])
    task.assign_attributes(@moved_tasks_params)
    task.save!

    # 同一ステータスの末尾タスクのID取得
    last_task_id = Task.status_is(@moved_tasks_params[:status])
                       .workspace_id_is(@workspace_id)
                       .order(:display_order)
                       .last
                       .id

    # 先頭のタスクだった場合は新たに作成したdisplay_order
    target_display_order = before_moved_task.nil? ? task.display_order : before_moved_task.display_order

    # 末尾に追加された場合は更新しない
    if !before_moved_task.nil? && before_moved_task&.id != last_task_id
      # 追加したタスクより後のタスク取得
      target_tasks = Task.status_is(@moved_tasks_params[:status])
                         .workspace_id_is(@workspace_id)
                         .display_order_ge(target_display_order)
                         .not_id_is(task.id)
                         .order(:display_order)

      # 並び更新
      target_tasks.each.with_index(1) do |target_task, index|
        target_task.display_order = task.display_order + index
        target_task.save!
      end

      # 移動前と移動後の間にあるタスクを繰り上げ
      before_moved_task.display_order -= 1
      before_moved_task.save!

    else
      # 末尾にタスクが追加された場合は追加したタスクのdisplay_orderをインクリメントする
      task.display_order += 1
      task.save!
    end
  end
end