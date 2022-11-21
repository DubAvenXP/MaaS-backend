class Client < ApplicationRecord
    has_many :services, dependent: :destroy
end
