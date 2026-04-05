class Event < ApplicationRecord
  after_create :create_default_guest_categories

  belongs_to :account
  has_many :guests, dependent: :destroy
  has_many :guest_categories, dependent: :destroy

  validates :name, presence: true

  private

  def create_default_guest_categories
    GuestCategory::DEFAULT_CATEGORIES.each do |name|
      guest_categories.find_or_create_by!(name: name)
    end
  end
end
