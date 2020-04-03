class Api::V1::TasksController < ApplicationController
  def index
    @tasks = Task.order(:display_order)
    render json: { tasks: @tasks }
  end

  # ステータス更新用アクション
  def update_status_task
    # 挿入されたタスク直下のタスク
    before_moved_task = Task.where(status: moved_tasks_params[:status])
                            .where(display_order: moved_tasks_params[:display_order])
                            .order(:display_order)
                            .last

    # タスクステータス更新処理
    task = Task.find(moved_tasks_params[:id])
    task.assign_attributes(moved_tasks_params)
    task.save!

    # 同一ステータスの末尾タスクのID取得
    last_task_id = Task.where(status: moved_tasks_params[:status])
                       .order(:display_order)
                       .last
                       .id

    # 先頭のタスクだった場合は新たに作成したdisplay_order
    target_display_order = before_moved_task.nil? ? task.display_order : before_moved_task.display_order

    # 末尾に追加された場合は更新しない
    if !before_moved_task.nil? && before_moved_task&.id != last_task_id
      # 追加したタスクより後のタスク取得
      target_tasks = Task.where(status: moved_tasks_params[:status])
                         .where('display_order >= ?', target_display_order)
                         .where.not(id: task.id)
                         .order(:display_order)

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

    @tasks = Task.order(:display_order)
    render json: { tasks: @tasks }
  end

  private

  # タスクの並び更新用
  # @return [Object] params パラメータ
  # def moved_tasks_params
  #   params.permit(
  #     tasks: [
  #       :id,
  #       :status,
  #       :display_order
  #     ]
  #   )
  # end

  # タスクのステータス更新用のアクション
  def moved_tasks_params
    params.require(:task).permit(
      :id,
      :status,
      :display_order
    )
  end

end