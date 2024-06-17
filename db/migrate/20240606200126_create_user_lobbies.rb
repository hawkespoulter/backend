class CreateUserLobbies < ActiveRecord::Migration[7.1]
  def change
    create_table :user_lobbies do |t|
      t.references :lobby, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
