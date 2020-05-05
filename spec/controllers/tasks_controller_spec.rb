require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do

  describe "GET #index" do
    it "タスクの一覧を取得" do
      @task = create(:task)
      create_list(:task, 9, workspace_id: @task.workspace_id)
      get :index, params: { workspace_id: @task.workspace_id }

      json = JSON.parse(response.body)

      # タスクの一覧を取得できるか
      expect(json['tasks'].length).to eq(10)
    end
  end

end