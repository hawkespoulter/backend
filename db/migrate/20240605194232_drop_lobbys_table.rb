class DropLobbysTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :lobbys
  end
end
