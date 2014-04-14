json.array!(@games) do |game|
  json.extract! game, :id, :name, :desc, :status, :creator, :need_chars, :tags, :deny_empty_requests, :private
  json.url game_url(game, format: :json)
end
