# == Schema Information
#
# Table name: event_venues
#
#  id         :bigint           not null, primary key
#  end_at     :datetime
#  notes      :text
#  role       :integer          not null
#  start_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  venue_id   :bigint           not null
#
# Indexes
#
#  index_event_venues_on_event_id           (event_id)
#  index_event_venues_on_event_id_and_role  (event_id,role) UNIQUE
#  index_event_venues_on_venue_id           (venue_id)
#
class EventVenue < ApplicationRecord
  belongs_to :event
  belongs_to :venue

  enum :role, { ceremony: 0, reception: 1 }, prefix: true

  validates :role, presence: true, uniqueness: { scope: :event_id }
  validates :venue_id, presence: true
  validate :end_at_after_start_at, if: -> { start_at.present? && end_at.present? }

  private

  def end_at_after_start_at
    errors.add(:end_at, "must be after start time") if end_at <= start_at
  end
end
