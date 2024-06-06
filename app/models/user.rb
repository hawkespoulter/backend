class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Establish relationships by using the table names
  has_many :owned_lobbies, class_name: 'Lobby', foreign_key: 'owner_id' # Allows a user to own a lobby
  has_many :user_lobbies
  has_many :lobbies, through: :user_lobbies
end
