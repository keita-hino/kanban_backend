class Api::V1::TasksController < ApplicationController
  def index
    @tasks = Task.order(:display_order)
    render json: { tasks: @tasks }
  end
end
