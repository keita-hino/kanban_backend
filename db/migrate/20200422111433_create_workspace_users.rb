class CreateWorkspaceUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :workspace_users, id: :bigint, unsigned: true do |t|
      t.integer :user_id, null: false
      t.integer :workspace_id, null: false

      t.timestamps
    end
  end
end
