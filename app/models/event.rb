# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  account_id :bigint           not null
#  title       :string           not null
#  event_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  theme      :string
#
# Indexes
#
#  index_events_on_account_id  (account_id)
#
# Foreign Keys
#
#  account_id  (account_id => accounts.id)
#
class Event < ApplicationRecord
  after_create :create_default_guest_categories

  belongs_to :account
  has_many :guests, dependent: :destroy
  has_many :guest_categories, dependent: :destroy
  has_many :event_venues, dependent: :destroy

  validates :title, presence: true

  private

  def create_default_guest_categories
    GuestCategory::DEFAULT_CATEGORIES.each do |name|
      guest_categories.find_or_create_by!(name: name)
    end
  end
end
