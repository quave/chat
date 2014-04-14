json.array!(@messages) do |message|
  json.extract! message, :id, :body, :sender_id, :receiver_id, :room_id
  json.url message_url(message, format: :json)
end
