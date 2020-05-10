require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
    before do
      create_list(:task, 10)
      @task = Task.first
    end

  describe "GET #index" do
    it "タスクの一覧を取得" do
      # ワークスペース作成
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
      task_create_params = {
        task: {
          name: 'タスク'
        },
        workspace_id: @task.workspace_id
      }

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクの新規作成処理でタスクが追加されているか確認する。
      expect { post :create, params: task_create_params }.to change(Task, :count).by(+1)
    end
  end

  describe "PATCH #update" do
    it "タスクの更新" do
      modified_task_name = 'タスク更新'

      task_create_params = {
        task: {
          id: @task.id,
          name: modified_task_name
        },
        workspace_id: @task.workspace_id
      }

      patch :update, params: task_create_params

      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクが更新されているか
      expect(Task.find(@task.id).name).to eq(modified_task_name)

    end
  end

  describe "PATCH #moved_tasks" do
    it "タスクの並び順更新" do
      change_task = Task.unstarted.second

      task_moved_params = {
        task: {
          id: change_task.id,
          status: change_task.status,
          display_order: 1
        },
        workspace_id: change_task.workspace_id
      }

      patch :moved_tasks, params: task_moved_params

      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクが更新されているか
      expect(Task.unstarted.order(:display_order).first.id).to eq(change_task.id)

    end
  end

  describe "PATCH #update_status_task" do
    it "タスクのステータス更新" do
      change_task = Task.unstarted.first

      task_status_change_params = {
        task: {
          id: change_task.id,
          status: :in_progress,
          display_order: 1
        },
        workspace_id: change_task.workspace_id
      }

      patch :update_status_task, params: task_status_change_params

      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクが更新されているか
      expect(Task.find(change_task.id).in_progress?).to be_truthy

    end
  end

end