json.array!(@characters) do |character|
  json.extract! character, :id, :name, :user_id, :game_id, :desc, :color
  json.url character_url(character, format: :json)
end
