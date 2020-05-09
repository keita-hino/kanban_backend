require 'rails_helper'

RSpec.describe Api::V1::WorkspacesController, type: :controller do
  before do
    @workspace = create(:workspace)
    @user = create(:user)
    @workspace_user = WorkspaceUser.create(user_id: @user.id, workspace_id: @workspace.id)
  end

  describe "GET #index" do
    it "ワークスペース一覧取得" do
      get :index, params: { email: @workspace_user.user.email }

      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクが更新されているか
      expect(json['workspaces'].length).to eq(1)

    end
  end

end