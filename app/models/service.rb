class Service < ApplicationRecord
  belongs_to :client
  has_many :shifts, dependent: :destroy
end
