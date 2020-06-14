# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
        skip_before_action :verify_authenticity_token, raise: false

        protected

        def find_resource(field, value)
          @resource = super(field, value)
          @resource
        end

        def render_create_success
          # ログイン処理後のレスポンス
          render json: {
            status: 'OK',
            # 下記でユーザテーブルの中身をハッシュ形式で返すことができる。
            data: resource_data(resource_json: @resource.token_validation_response),
            workspace: @resource.workspace_users.first.workspace
          }
        end
      end
    end
  end
end
