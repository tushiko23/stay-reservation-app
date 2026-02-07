class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.date :check_in_date, null: false
      t.date :check_out_date, null: false
      t.integer :guest_count, null: false
      t.timestamps
    end
  end
end
