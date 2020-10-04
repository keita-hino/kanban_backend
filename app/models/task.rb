# frozen_string_literal: true

class Task < ApplicationRecord
  ##
  # relations
  ##

  belongs_to :workspace

  ##
  # enums
  ##

  # ステータス
  enum status: {
    unstarted: 1,
    in_progress: 2,
    done: 3
  }

  # 優先度
  enum priority: {
    low: 1,
    medium: 2,
    high: 3
  }

  ##
  # validates
  ##

  # タスク名
  validates :name,
            presence: true,
            length: { maximum: 100 }

  # 詳細
  validates :detail,
            length: { maximum: 200 }

  # 期限日
  validates :due_date,
            allow_blank: true,
            date: { presence: true }

  ##
  # scopes
  ##

  # not_IDis
  scope :not_id_is, lambda { |id|
    where.not(id: id)
  }

  # ワークスペースID_is
  scope :workspace_id_is, lambda { |id|
    where(workspace_id: id)
  }

  # ステータス_is
  scope :status_is, lambda { |value|
    where(status: value)
  }

  # 表示順_is
  scope :display_order_is, lambda { |value|
    where(display_order: value)
  }

  # 表示順_ge
  scope :display_order_ge, lambda { |value|
    where('display_order >= ?', value)
  }

  ##
  # methods
  ##

  # 該当タスクの直下のタスク取得
  def self.immediate_task(status, display_order, workspace_id)
    status_is(status)
      .display_order_is(display_order)
      .workspace_id_is(workspace_id)
      .order(:display_order)
      .last
  end

  # 同一ステータスの末尾タスクのID取得
  def self.same_status_last_task_id(status, workspace_id)
    status_is(status)
      .workspace_id_is(workspace_id)
      .order(:display_order)
      .last
      .id
  end

  # 後のタスク取得
  def self.later_tasks(id, status, workspace_id, target_display_order)
    status_is(status)
      .workspace_id_is(workspace_id)
      .display_order_ge(target_display_order)
      .not_id_is(id)
      .order(:display_order)
  end

  # display_orderをインクリメントする
  def increase_display_order
    self.display_order += 1
    save!
  end

  # display_orderをデクリメントする
  def decrease_display_order
    self.display_order -= 1
    save!
  end
end
