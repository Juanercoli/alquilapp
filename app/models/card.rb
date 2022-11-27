class Card < ApplicationRecord

    
    
    belongs_to :user
    validates :card_number, presence: true,
    format: {
        #este regex sirve para tarjetas visa y mastercard
        with: /\A(?:4\d([\- ])?\d{6}\1\d{5}|(?:4\d{3}|5[1-5]\d{2}|6011)([\- ])?\d{4}\2\d{4}\2\d{4})\z/i,
        message: :invalid
      }
    validates :name, presence: true
    validates :surname, presence: true
    validates :expiration_date, presence: true
    validates :security_code, presence: true , length: { minimum: 3, maximum: 3 }
    validate :expiration_date_must_be_valid

    private
    def expiration_date_must_be_valid
        # Valida que la ltarjeta de expiración sea valida
        if expiration_date.present? && expiration_date <= Date.today
          errors.add(:expiration_date, "bad_expiration_date")
        end
      end
end
