class UpdateGuestsReferences < ActiveRecord::Migration[8.1]
  def change
    add_reference :guests, :event, null: false, foreign_key: true
    change_column_null :guests, :guest_category_id, true
  end
end
