class Account < ApplicationRecord
  after_create :create_default_account_guest_category

  has_many :account_guest_categories, dependent: :destroy
  has_many :guests, through: :account_guest_categories

  validates :name, presence: true

  private

  def create_default_account_guest_category
    AccountGuestCategory::DEFAULT_CATEGORIES.each do |name|
      account_guest_categories.find_or_create_by!(name: name)
    end
  end
end
