class RemoveVenueFromEvents < ActiveRecord::Migration[8.1]
  def change
    remove_column :events, :venue, :string
  end
end
