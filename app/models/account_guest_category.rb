class AccountGuestCategory < ApplicationRecord
  DEFAULT_CATEGORIES = [ "Family", "Friends", "Workmates" ].freeze

  belongs_to :account
  has_many :guest_categories, dependent: :destroy
  has_many :guests, through: :guest_categories

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
