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

  # ワークスペースID_is
  scope :workspace_id_is, -> (id) {
    where(workspace_id: id)
  }

end
