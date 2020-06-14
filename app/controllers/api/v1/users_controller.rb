# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def update
        user = User.find_by_email(params[:user][:before_email])
        user.assign_attributes(update_users_params)
        user.save!

        render json: { user: user }
      end

      private

      # ユーザの更新用パラメータ
      # @return [Object] params パラメータ
      def update_users_params
        params.require(:user).permit(
          :email,
          :last_name,
          :first_name,
          :password
        )
      end
    end
  end
end
