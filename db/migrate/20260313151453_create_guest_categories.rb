class CreateGuestCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :guest_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :guest_categories, :name, unique: true
  end
end
