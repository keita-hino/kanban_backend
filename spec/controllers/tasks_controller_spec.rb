require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do

  describe "GET #index" do
    it "タスクの一覧を取得" do
      @task = create(:task)
      create_list(:task, 9, workspace_id: @task.workspace_id)
      get :index, params: { workspace_id: @task.workspace_id }

      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクの一覧を取得できるか
      expect(json['tasks'].length).to eq(10)
    end
  end

  describe "POST #create" do
    it "タスクの新規作成" do
      @workspace = create(:workspace)

      task_create_params = {
        task: {
          name: 'タスク'
        },
        workspace_id: @workspace.id
      }

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクの新規作成処理でタスクが追加されているか確認する。
      expect { post :create, params: task_create_params }.to change(Task, :count).by(+1)
    end
  end

end