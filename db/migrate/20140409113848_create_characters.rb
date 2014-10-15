class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.references :profile, null: false, index: true
      t.references :game, null: false, index: true
      t.boolean :master, null: false, default: false
      t.text :major_attr, null: false, default: ''
      t.text :minor_attr, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :inventory, null: false, default: ''
      t.integer :status, null: false, default: 0
      t.integer :color, null: false, default: 0

      t.timestamps
    end
  end
end
