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
require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
