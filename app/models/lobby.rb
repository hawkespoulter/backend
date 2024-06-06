class Lobby < ApplicationRecord
  
  # Establish relationships
  has_many :user_lobbies
  has_many :users, through: :user_lobbies
end
