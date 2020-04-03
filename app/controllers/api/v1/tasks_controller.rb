class Api::V1::TasksController < ApplicationController
  def index
    @tasks = Task.order(:display_order)
    render json: { tasks: @tasks }
  end

  def moved_tasks
    # TODO:トランザクション設定
    moved_tasks_params[:tasks].each do | moved_tasks_param |
      task = Task.find(moved_tasks_param[:id])
      task.assign_attributes(moved_tasks_param)
      task.save!
    end
    @tasks = Task.order(:display_order)
    render json: { tasks: @tasks }
  end

  private

  # タスクの並び更新用
  # @return [Object] params パラメータ
  def moved_tasks_params
    params.permit(
      tasks: [
        :id,
        :display_order
      ]
    )
  end

end
