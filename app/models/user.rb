class User < ApplicationRecord
  # Cada usuario tiene su historial de reportes
  has_many :reports, dependent: :destroy
  # Cada usuario tiene su wallet
  has_one :wallet , dependent: :destroy
  has_one :card , dependent: :destroy
  # Cada usuario tiene su historial de multas
  has_many :fines, dependent: :destroy
  # Cada usuario tiene su historial de compra
  has_many :rentals, dependent: :destroy
  # Cada usuario tiene su historial
  has_many :car_usage_history, dependent: :destroy
  # Cada usuario tiene su wallet
  has_one :wallet , dependent: :destroy
  # Hace uso de la gema BCrypt para encriptar el password
  has_secure_password 
  # Hace uso de active_storage para guardar archivos
  has_one_attached :driver_license, dependent: :destroy
 
 
  # Validaciones a nivel base de datos
  validates :dni, presence: true, uniqueness: true, length: { minimum: 7, maximum: 8 },
    format: {
      with: /\A\d+\z/,
      message: :invalid
    }
  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: :invalid
    }
  validates :phone, presence: true, uniqueness: true, 
    format: {
      with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/,
      message: :invalid
    }
  validates :password, length: { minimum: 6 }, unless: proc { |x| x.password.blank? }
  validates :password, format: { without: /\s/ } # Valida que no haya blancos
  validates :driver_license_expiration, presence: true
  validate :driver_license_expiration_must_be_valid
  validates :driver_license, presence: true
  validate :validate_driver_license_filetype # Validacion del tipo de attachment
  validates :birthdate, presence: true
  validate :birthdate_must_be_at_least_seventeen_years_old

  # Callback antes de guardar
  before_save :downcase_attributes

  # Métodos para validar login 
  def is_valid? (password)
    # Un usuario es valido cuando:
    self.authenticate(password) && !self.is_blocked && !self.is_deleted
  end

  # Retorna si el usuario es administrador
  def role?
    "client"
  end

  def driver_license_expirated?
    self.driver_license_expiration.present? && self.driver_license_expiration <= Date.current
  end
  
  # Métodos privados
  private

  def downcase_attributes
    # Pasamos los atributos a minúsculas por convención propia
    self.name = name.downcase
    self.surname = surname.downcase
    self.email = email.downcase
  end

  def validate_driver_license_filetype
    # Valida el formato del archivo adjunto
    if driver_license.attached? && !driver_license.content_type.in?(%w(image/jpeg image/png))
      errors.add(:driver_license, :bad_driver_license_type, type1: ".jpg", type2: ".png")
    end
  end

  def driver_license_expiration_must_be_valid
    # Valida que la licencia de expiración sea valida
    if driver_license_expiration.present? && driver_license_expiration <= Date.current
      errors.add(:driver_license_expiration, :bad_driver_license_expiration)
    end
  end

  def birthdate_must_be_at_least_seventeen_years_old
    # Valida que la edad de la persona sea de al menos 17 años
    if (birthdate.present? && birthdate > 17.years.ago.to_date)
      errors.add(:birthdate, :bad_birthdate, age: 17)
    end
  end
end
