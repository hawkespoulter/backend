class AddPfpToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pfp, :string
  end
end
