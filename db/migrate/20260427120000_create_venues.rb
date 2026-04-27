class CreateVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :venues do |t|
      t.string  :name,          null: false
      t.integer :venue_type,    null: false
      t.text    :address_line1
      t.text    :address_line2
      t.string  :city
      t.string  :state
      t.string  :country
      t.string  :phone_number
      t.string  :website
      t.text    :notes

      t.timestamps
    end

    add_index :venues, :name
  end
end
