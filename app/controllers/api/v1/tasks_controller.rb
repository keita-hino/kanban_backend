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
      # タスクの登録
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
  def moved_tasks
    workspace_id = params[:workspace_id]
    TaskOrderUpdater.new(workspace_id, moved_tasks_params).call

    @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
    render json: { tasks: @tasks }
  end

  # ステータス更新用アクション
  def update_status_task
    workspace_id = params[:workspace_id]
    TaskStatusUpdater.new(workspace_id, moved_tasks_params).call

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
