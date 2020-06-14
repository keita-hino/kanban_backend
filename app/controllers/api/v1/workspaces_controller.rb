# frozen_string_literal: true

module Api
  module V1
    class WorkspacesController < ApplicationController
      def index
        user = User.with_workspaces.find_by_email(params[:email])

        render json: { workspaces: user.workspaces }
      end
    end
  end
end
