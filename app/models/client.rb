class Client < ApplicationRecord
    has_many :services, dependent: :destroy

    validates :name, presence: true, length: 5..100
	validates :description, presence: true, length: 5..250
end
