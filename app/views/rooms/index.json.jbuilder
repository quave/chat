json.array!(@rooms) do |room|
  json.extract! room, :id, :name, :game_id, :order
  json.url room_url(room, format: :json)
end
