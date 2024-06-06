class UserLobby < ApplicationRecord
  
  # Establish relationships
  belongs_to :user
  belongs_to :lobby
end