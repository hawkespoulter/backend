class LobbySerializer
  include JSONAPI::Serializer
  attributes :id, :game, :owner_id, :player_count
end
