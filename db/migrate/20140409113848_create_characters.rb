class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.references :user, null: false, index: true
      t.references :game, null: false, index: true
      t.text :desc
      t.integer :status, null: false, default: 0
      t.integer :color, null: false, default: 0

      t.timestamps
    end
  end
end
