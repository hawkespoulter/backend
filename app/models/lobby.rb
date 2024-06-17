class Lobby < ApplicationRecord
  
  # Establish relationships by using the table names
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id' # Allows a lobby to belong to a User
  has_many :user_lobbies, dependent: :destroy # Allow cascading deletion
  has_many :users, through: :user_lobbies
end
