class Api::V1::WorkspacesController < ApplicationController
  def index
    user = User.find_by_uid(params[:uid])
    # TODO:workspacesなどの結合

    render json: { workspaces: user.workspaces }
  end

end
