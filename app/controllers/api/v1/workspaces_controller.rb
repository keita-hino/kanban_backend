class Api::V1::WorkspacesController < ApplicationController
  def index
    user = User.with_workspaces.find_by_email(params[:email])

    render json: { workspaces: user.workspaces }
  end

end
