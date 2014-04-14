class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.references :game, index: true
      t.integer :order

      t.timestamps
    end

    create_table :characters_rooms, :id => false do |t|
      t.references :room, :character
    end

    add_index :characters_rooms, [:room_id, :character_id]
  end
end
