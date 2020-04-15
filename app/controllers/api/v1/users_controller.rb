class Api::V1::UsersController < ApplicationController
  def update
    debugger
  end

  private

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
