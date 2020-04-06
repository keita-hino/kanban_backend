class AddColumnTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :detail, :string, limit: 200
    add_column :tasks, :priority, :integer
  end
end
