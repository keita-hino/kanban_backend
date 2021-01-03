class Task::Creater
  attr_reader :workspace_id, :params

  # 初期化
  def initialize(workspace_id, params)
    @workspace_id = workspace_id
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      # タスクの登録
      task = Task.new(params)
      task.display_order = 0
      task.workspace_id = workspace_id
      task.save!

      # タスクのdisplay_orderを更新する
      tasks = Task.status_is(params[:status]).workspace_id_is(workspace_id)
      tasks.each do |task|
        task.display_order += 1
        task.save!
      end
    end
  end
end
