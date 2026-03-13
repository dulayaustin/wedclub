class Guest < ApplicationRecord
  AGE_GROUP = [ "adult", "child" ]
  GUEST_OF = [ "bride", "groom", "both" ]

  has_one :guest_guest_category, dependent: :destroy
  has_one :guest_category, through: :guest_guest_category

  validates :first_name, presence: true
  validates :last_name, presence: true
end
