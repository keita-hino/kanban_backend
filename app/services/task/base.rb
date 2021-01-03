# frozen_string_literal: true

class Task::Base
  private

  # 移動する前のタスク
  def before_moved_task
    @before_moved_task ||= Task.immediate_task(status, display_order, workspace_id)
  end

  # 末尾タスクのIDを取得
  def last_task_id
    @last_task_id ||= Task.same_status_last_task_id(status, workspace_id)
  end

  # 末尾に追加されたタスクか
  def add_end_task?
    !before_moved_task.nil? && before_moved_task&.id != last_task_id
  end
end
