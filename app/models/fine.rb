class Fine < ApplicationRecord
    belongs_to :user
    validates :description, presence: true
    validates :fine_price, presence: true
end
