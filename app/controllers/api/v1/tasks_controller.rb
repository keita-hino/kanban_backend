class Api::V1::TasksController < ApplicationController
  def index
    @tasks = Task.workspace_id_is(params[:workspace_id]).order(:display_order)
    @statuses = Task.statuses_i18n
    @priorities = Task.priorities.keys
    render json: { tasks: @tasks, priorities: @priorities, statuses: @statuses }
  end

  def create
    workspace_id = params[:workspace_id]
    ActiveRecord::Base.transaction do
      # タスク登録
      task = Task.new(create_tasks_params)
      task.display_order = 0
      task.workspace_id = workspace_id
      task.save!

      # タスクのdisplay_orderを更新する
      tasks = Task.status_is(create_tasks_params[:status]).workspace_id_is(workspace_id)
      tasks.each do | task |
        task.display_order += 1
        task.save!
      end
    end

    @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
    render json: { tasks: @tasks }
  end

  def update
    workspace_id = params[:workspace_id]
    ActiveRecord::Base.transaction do
      task = Task.find(update_tasks_params[:id])
      task.assign_attributes(update_tasks_params)
      task.save!
    end

    @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
    render json: { tasks: @tasks }
  end

  # タスクの並び順を変更するタスク
  # TODO:リファクタリング
  def moved_tasks
    workspace_id = params[:workspace_id]
    task_mover = TaskMover.new(workspace_id, moved_tasks_params)
    task_mover.move

    @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
    render json: { tasks: @tasks }
  end

  # ステータス更新用アクション
  # TODO:リファクタリング
  def update_status_task
    workspace_id = params[:workspace_id]

    # 挿入されたタスク直下のタスク
    before_moved_task = Task.status_is(moved_tasks_params[:status])
                            .workspace_id_is(workspace_id)
                            .display_order_is(moved_tasks_params[:display_order])
                            .order(:display_order)
                            .last

    # タスクステータス更新処理
    task = Task.find(moved_tasks_params[:id])
    task.assign_attributes(moved_tasks_params)
    task.save!

    # 同一ステータスの末尾タスクのID取得
    last_task_id = Task.status_is(moved_tasks_params[:status])
                       .workspace_id_is(workspace_id)
                       .order(:display_order)
                       .last
                       .id

    # 先頭のタスクだった場合は新たに作成したdisplay_order
    target_display_order = before_moved_task.nil? ? task.display_order : before_moved_task.display_order

    # 末尾に追加された場合は更新しない
    if !before_moved_task.nil? && before_moved_task&.id != last_task_id
      # 追加したタスクより後のタスク取得
      target_tasks = Task.status_is(moved_tasks_params[:status])
                         .workspace_id_is(workspace_id)
                         .display_order_ge(target_display_order)
                         .not_id_is(task.id)
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

    @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
    render json: { tasks: @tasks }
  end

  private

  # タスクの並び更新用
  # @return [Object] params パラメータ
  def moved_tasks_params
    params.require(:task).permit(
      :id,
      :status,
      :display_order
    )
  end

  # タスクの作成用パラメータ
  # @return [Object] params パラメータ
  def create_tasks_params
    params.require(:task).permit(
      :name,
      :status
    )
  end

  # タスクの作成用パラメータ
  # @return [Object] params パラメータ
  def update_tasks_params
    params.require(:task).permit(
      :id,
      :name,
      :priority,
      :due_date,
      :status,
      :detail
    )
  end

end
