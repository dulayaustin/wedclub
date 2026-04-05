class Account < ApplicationRecord
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
  has_many :events, dependent: :destroy
  has_many :guests, through: :events

  validates :name, presence: true
end
