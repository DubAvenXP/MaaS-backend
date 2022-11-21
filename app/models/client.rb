class Client < ApplicationRecord
    has_many :services, dependent: :destroy

    validates :name, presence: true
    validates :description, presence: true

end
