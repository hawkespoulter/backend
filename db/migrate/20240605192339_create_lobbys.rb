class CreateLobbys < ActiveRecord::Migration[7.1]
  def change
    create_table :lobbys do |t|
      t.string :game

      t.timestamps
    end
  end
end
