class Shift < ApplicationRecord
  belongs_to :service
  has_many :assignments, dependent: :destroy

  # enums
  enum day: %w[monday tuesday wednesday thursday friday saturday sunday]
end
