class Card < ApplicationRecord

    
    
    belongs_to :user
   

    
    validates :card_number, presence: true ,uniqueness: true
    #format: {
    #    with: /\A(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))\z/i,
    #    message: :invalid
    #  }
    validates :name, presence: true
    validates :surname, presence: true
    validates :expiration_date, presence: true
    validates :security_code, presence: true
    validate :expiration_date_must_be_valid

    private
    def expiration_date_must_be_valid
        # Valida que la ltarjeta de expiración sea valida
        if expiration_date.present? && expiration_date <= Date.today
          errors.add(:expiration_date, "bad_expiration_date")
        end
      end
end
