class CreateRoomsUsersVisits < ActiveRecord::Migration
  def change
    create_table :rooms_users_visits, primary_key: [:room_id, :user_id] do |t|
      t.references :room
      t.references :user
      t.datetime :last_visited, null: false
    end
  end
end
