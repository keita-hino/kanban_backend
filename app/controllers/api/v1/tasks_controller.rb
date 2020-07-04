# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApplicationController
      def index
        @tasks = Task.workspace_id_is(params[:workspace_id]).order(:display_order)
        @statuses = Task.statuses_i18n
        @priorities = Task.priorities.keys
        render json: { tasks: @tasks, priorities: @priorities, statuses: @statuses }
      end

      def create
        workspace_id = params[:workspace_id]
        Task::Creater.new(workspace_id, create_tasks_params).call

        @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
        render json: { tasks: @tasks }
      end

      def update
        workspace_id = params[:workspace_id]
        Task::Updater.new(workspace_id, update_tasks_params).call

        @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
        render json: { tasks: @tasks }
      end

      # タスクの並び順を変更するタスク
      def moved_tasks
        workspace_id = params[:workspace_id]
        Task::OrderUpdater.new(workspace_id, moved_tasks_params).call

        @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
        render json: { tasks: @tasks }
      end

      # ステータス更新用アクション
      def update_status_task
        workspace_id = params[:workspace_id]
        Task::StatusUpdater.new(workspace_id, moved_tasks_params).call

        @tasks = Task.workspace_id_is(workspace_id).order(:display_order)
        render json: { tasks: @tasks }
      end

      private

      # タスクの並び更新用
      # @return [Object] params パラメータ
      def moved_tasks_params
        params.require(:task).permit(
          :id,
          :status,
          :display_order
        )
      end

      # タスクの作成用パラメータ
      # @return [Object] params パラメータ
      def create_tasks_params
        params.require(:task).permit(
          :name,
          :status
        )
      end

      # タスクの作成用パラメータ
      # @return [Object] params パラメータ
      def update_tasks_params
        params.require(:task).permit(
          :id,
          :name,
          :priority,
          :due_date,
          :status,
          :detail
        )
      end
    end
  end
end
