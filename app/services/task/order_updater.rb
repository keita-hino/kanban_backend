# frozen_string_literal: true

class Task::OrderUpdater < Task::Base
  attr_accessor :workspace_id, :id, :status, :display_order, :moved_tasks_params

  def initialize(workspace_id, moved_tasks_params)
    @workspace_id = workspace_id
    @id = moved_tasks_params[:id]
    @status = moved_tasks_params[:status]
    @display_order = moved_tasks_params[:display_order]
    @moved_tasks_params = moved_tasks_params
  end

  # タスクの並び順を変更
  def call
    ActiveRecord::Base.transaction do
      # タスクステータス更新処理
      task = Task.find(id)
      task.assign_attributes(moved_tasks_params)
      task.save!

      # タスクの並び順更新
      update_order_task(task)
    end
  end

  private

  def update_order_task(task)
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
