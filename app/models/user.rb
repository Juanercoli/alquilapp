class User < ApplicationRecord
  # Hace uso de la gema BCrypt para encriptar el password
  has_secure_password 

  # Validaciones a nivel base de datos
  validates :dni, presence: true, uniqueness: true, length: { maximum: 8 }
  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: :invalid
    }
  validates :phone, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :driver_license_expiration, presence: true #// validar fecha, que sea posterior al dia actual??
  validates :birthdate, presence: true #// validar fecha, que tenga >= a 17 años
  validate :birthdate_must_be_at_least_seventeen_years_old

  # Callback antes de guardar
  before_save :downcase_attributes

  private

  def downcase_attributes
    # Pasamos los atributos a minúsculas por convención propia
    self.name = name.downcase
    self.surname = surname.downcase
    self.email = email.downcase
  end

  def birthdate_must_be_at_least_seventeen_years_old
    if (birthdate.present? && birthdate > 17.years.ago.to_date)
      errors.add(:birthdate, :bad_birthdate, age: 17)
    end
  end
end
