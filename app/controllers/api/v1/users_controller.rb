class Api::V1::UsersController < ApplicationController
  def update
    user = User.find_by_uid(params[:user][:before_uid])
    user.assign_attributes(update_users_params)
    user.save!

    render json: { user: user }
  end

  private

  # ユーザの更新用パラメータ
  # @return [Object] params パラメータ
  def update_users_params
    params.require(:user).permit(
      :uid,
      :last_name,
      :first_name,
      :password
    )
  end

end
