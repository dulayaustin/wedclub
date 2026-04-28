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
