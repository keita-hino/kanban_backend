class Task < ApplicationRecord
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

end
