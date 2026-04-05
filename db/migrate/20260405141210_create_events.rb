class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.datetime :event_date

      t.timestamps
    end
  end
end
