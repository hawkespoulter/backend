class UserLobby < ApplicationRecord
  
  # Establish relationships by using the model names
  belongs_to :user
  belongs_to :lobby

  after_create :increment_player_count # When a new record is added to the users_lobbies table
  after_destroy :decrement_player_count # When a new record is removed from the users_lobbies table

  private

  # Adjust the player count of the lobby in the Lobbies table
  def increment_player_count
    lobby.increment!(:player_count)
  end

  def decrement_player_count
    lobby.decrement!(:player_count)
  end
end