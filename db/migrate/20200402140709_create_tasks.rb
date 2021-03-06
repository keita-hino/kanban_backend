class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks, id: :bigint, unsigned: true do |t|
      t.integer :workspace_id, null: false
      t.string :name, limit: 100, null: false
      t.string :detail, limit: 200
      t.integer :status
      t.integer :priority
      t.integer :display_order
      t.date :due_date

      t.timestamps
    end
  end
end
