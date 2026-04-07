class AddVenueAndThemeToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :venue, :string
    add_column :events, :theme, :string
  end
end
