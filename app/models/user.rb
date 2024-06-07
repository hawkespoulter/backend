class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Establish relationships by using the table names
  has_many :owned_lobbies, class_name: 'Lobby', foreign_key: 'owner_id' # Allows a user to own a lobby
  has_many :user_lobbies
  has_many :lobbies, through: :user_lobbies

  # Check if the user is in a lobby by checking the UserLobbies table
  def in_lobby?(lobby)
    user_lobbies.exists?(lobby_id: lobby.id)
  end

  # Check if the user is the owner of the lobby
  def is_lobby_owner?(lobby)
    id == lobby.owner_id
  end
end
