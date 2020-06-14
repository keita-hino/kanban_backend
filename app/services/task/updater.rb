class Task::Updater
  attr_reader :workspace_id, :params

  # 初期化
  def initialize(workspace_id, params)
    @workspace_id = workspace_id
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      task = Task.find(params[:id])
      task.assign_attributes(params)
      task.save!
    end
  end

end
