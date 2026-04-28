class CreateEventVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :event_venues do |t|
      t.references :event, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.integer :role, null: false
      t.datetime :start_at
      t.datetime :end_at
      t.text :notes

      t.timestamps
    end

    add_index :event_venues, [ :event_id, :role ], unique: true
  end
end
