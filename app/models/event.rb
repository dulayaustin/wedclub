class Event < ApplicationRecord
  belongs_to :account
  has_many :guests, dependent: :destroy
  has_many :guest_categories, dependent: :destroy

  validates :name, presence: true
end
