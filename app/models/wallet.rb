class Wallet < ApplicationRecord

    
    # has_many :users
    belongs_to :user
    validates :user_id, presence: true
    
end
