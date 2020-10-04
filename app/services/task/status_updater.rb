# frozen_string_literal: true

class Task::StatusUpdater
  attr_reader :id, :workspace_id, :status, :display_order

  # 初期化
  def initialize(id, workspace_id, status, display_order)
    @id = id
    @workspace_id = workspace_id
    @status = status
    @display_order = display_order
  end

  def call
    ActiveRecord::Base.transaction do
      # タスクステータス更新処理
      task = Task.find(id)
      task.status = status
      task.save!

      update_task_status(task)
    end
  end

  private

  # 挿入されたタスク直下のタスク
  def before_moved_task
    @before_moved_task ||= Task.immediate_task(status, display_order, workspace_id)
  end

  # 末尾タスクのIDを取得
  def last_task_id
    @last_task_id ||= Task.same_status_last_task_id(status, workspace_id)
  end

  def add_end_task?
    !before_moved_task.nil? && before_moved_task&.id != last_task_id
  end

  # タスクのステータスを更新
  def update_task_status(task)
    # 先頭のタスクだった場合は新たに作成したdisplay_order
    target_display_order = before_moved_task.nil? ? task.display_order : before_moved_task.display_order

    # 末尾に追加された場合は更新しない
    if add_end_task?
      # 追加したタスクより後のタスク取得
      target_tasks = Task.later_tasks(task.id, status, workspace_id, target_display_order)

      # 並び更新
      target_tasks.each.with_index(1) do |target_task, index|
        target_task.display_order = task.display_order + index
        target_task.save!
      end
    else
      # 末尾にタスクが追加された場合は追加したタスクのdisplay_orderをインクリメントする
      task.display_order += 1
      task.save!
    end
  end
end
