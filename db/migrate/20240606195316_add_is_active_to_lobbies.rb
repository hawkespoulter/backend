class AddIsActiveToLobbies < ActiveRecord::Migration[7.1]
  def change
    add_column :lobbies, :is_active, :boolean, default: false, null: false
  end
end
