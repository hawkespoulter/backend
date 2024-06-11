class AddPlayerNumberToUserLobbies < ActiveRecord::Migration[7.1]
  def change
    add_column :user_lobbies, :player_number, :integer, null: false
  end
end
