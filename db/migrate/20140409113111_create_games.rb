class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.text :desc
      t.integer :status, null: false, default: 1
      t.references :creator, null: false
      t.integer :need_chars, null: false, default: 2
      t.string :tags, null: false, default: ''

      t.timestamps
    end
  end
end
