class GuestCategory < ApplicationRecord
  has_many :guest_guest_categories, dependent: :destroy
  has_many :guests, through: :guest_guest_categories
  validates :name, presence: true, uniqueness: true
end
