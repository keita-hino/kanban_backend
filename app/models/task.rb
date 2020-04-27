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
  scope :not_id_is, -> (id) {
    where.not(id: id)
  }

  # ワークスペースID_is
  scope :workspace_id_is, -> (id) {
    where(workspace_id: id)
  }

  # ステータス_is
  scope :status_is, -> (value) {
    where(status: value)
  }

  # 表示順_is
  scope :display_order_is, -> (value) {
    where(display_order: value)
  }

  # 表示順_ge
  scope :display_order_ge, -> (value) {
    where('display_order >= ?', value)
  }

end
