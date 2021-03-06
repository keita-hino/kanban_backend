# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:modified_last_name) { '変更後hoge' }
  let(:params) do
    {
      user: {
        id: user.id,
        last_name: modified_last_name,
        before_email: user.email
      }
    }
  end

  describe 'PATCH #update' do
    it 'ユーザの更新' do
      patch :update, params: params

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクが更新されているか
      expect(response.body).to be_json_including(
        user: {
          'id' => user.id,
          'last_name' => modified_last_name
        }
      )
    end
  end
end
