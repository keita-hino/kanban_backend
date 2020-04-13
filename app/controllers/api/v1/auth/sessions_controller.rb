module Api::V1::Auth
  class SessionsController < DeviseTokenAuth::SessionsController

    skip_before_action :verify_authenticity_token, raise: false

    protected

    def find_resource(field, value)
      @resource = super(field, value)
      @resource
    end

    def render_create_success
      # ログインした後のレスポンス
      render json: {
        status: "OK",
        email: @resource.email,
        last_name: @resource.last_name,
        first_name: @resource.first_name
      }
    end
  end
end