class Api::V1::WorkspacesController < ApplicationController
  def index
    user = User.find_by_email(params[:email])
    # TODO:workspacesなどの結合

    render json: { workspaces: user.workspaces }
  end

end
