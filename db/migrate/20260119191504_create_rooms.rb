class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :introduction, null: false
      t.integer :fee_per_day, null: false
      t.string :address, null: false
      t.timestamps
    end
  end
end
