# == Schema Information
#
# Table name: tasks
#
#  id            :bigint           not null, primary key
#  detail        :string(200)
#  display_order :integer
#  due_date      :date
#  name          :string
#  priority      :integer
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
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

end
