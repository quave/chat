class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.references :game, null: false, index: true
      t.integer :order, null: false, default: 0
      t.boolean :private, null: false, default: false

      t.timestamps
    end

    create_table :characters_rooms, :id => false do |t|
      t.references :room, :character
    end

    add_index :characters_rooms, [:room_id, :character_id]
  end
end
