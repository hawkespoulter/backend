class CreateLobbies < ActiveRecord::Migration[7.1]
  def change
    create_table :lobbies do |t|
      t.string :game

      t.timestamps
    end
  end
end
