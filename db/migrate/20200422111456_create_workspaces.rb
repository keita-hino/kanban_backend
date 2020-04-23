class CreateWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :workspaces, id: :bigint, unsigned: true do |t|
      t.string :name, limit: 100, null: false
      t.string :image_url, limit: 256

      t.timestamps
    end
  end
end
