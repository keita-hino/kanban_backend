# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::WorkspacesController, type: :controller do
  let(:workspace) { create(:workspace) }
  let(:user) { create(:user) }
  let(:workspace_user) { create(:workspace_user, user_id: user.id, workspace_id: workspace.id) }

  describe 'GET #index' do
    it 'ワークスペース一覧取得' do
      get :index, params: { email: workspace_user.user.email }

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # ワークスペースの一覧を取得できるか
      expect(JSON.parse(response.body)).to match(
        'workspaces' => match([
                                hash_including(
                                  'id' => workspace.id
                                )
                              ])
      )
    end
  end
end
