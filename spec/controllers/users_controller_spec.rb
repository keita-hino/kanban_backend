require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before do
    create_list(:user, 10)
    @user = User.first
  end

  describe "PATCH #update" do
    it "ユーザの更新" do
      modified_last_name = '変更後hoge'

      update_user_params = {
        user: {
          id: @user.id,
          last_name: modified_last_name,
          before_email: @user.email
        }
      }

      patch :update, params: update_user_params

      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)

      # タスクが更新されているか
      expect(User.find(@user.id).last_name).to eq(modified_last_name)

    end
  end

end