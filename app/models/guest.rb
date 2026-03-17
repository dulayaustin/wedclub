class Guest < ApplicationRecord
  has_one :guest_category, dependent: :destroy
  has_one :account_guest_category, through: :guest_category

  enum :age_group, { adult: 0, child: 1 }, prefix: true
  enum :guest_of, { bride: 0, groom: 1, both: 2 }, prefix: true

  validates :first_name, presence: true
  validates :last_name, presence: true
end
