class Lobby < ApplicationRecord
  
  # Establish relationships by using the table names
  has_many :user_lobbies
  has_many :users, through: :user_lobbies
end
