class Shift < ApplicationRecord
  belongs_to :service
  has_many :assignments, dependent: :destroy
end
