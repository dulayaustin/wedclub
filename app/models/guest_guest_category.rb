class GuestGuestCategory < ApplicationRecord
  belongs_to :guest
  belongs_to :guest_category
end
