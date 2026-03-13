class CreateGuestGuestCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :guest_guest_categories do |t|
      t.references :guest, null: false, foreign_key: true
      t.references :guest_category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :guest_guest_categories, [ :guest_id, :guest_category_id ], unique: true
  end
end
