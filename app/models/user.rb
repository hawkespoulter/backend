class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Establish relationships by using the table names
  has_many :user_lobbies
  has_many :lobbies, through: :user_lobbies
end
