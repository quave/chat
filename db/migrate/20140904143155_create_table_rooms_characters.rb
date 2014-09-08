class CreateTableRoomsCharacters < ActiveRecord::Migration
  def change
    create_table :rooms_characters, id: false do |t|
      t.belongs_to :room
      t.belongs_to :character
    end

    add_index :rooms_characters, [:room_id, :character_id], unique: true
  end
end
