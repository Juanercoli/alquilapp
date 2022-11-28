class SuperUser < ApplicationRecord
  # Hace uso de la gema BCrypt para encriptar el password
  has_secure_password 

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

    # Callback antes de guardar
  before_save :downcase_attributes

  # Métodos para validar login 
  def is_valid? (password)
    # Un usuario es valido cuando:
    self.authenticate(password) && !self.is_blocked && !self.is_deleted
  end

  # Retorna si el usuario es administrador
  def role?
    if self.is_admin
      "admin"
    else
      "supervisor"
    end
  end

  # Métodos privados
  private

  def downcase_attributes
    # Pasamos los atributos a minúsculas por convención propia
    self.name = name.downcase
    self.surname = surname.downcase
    self.email = email.downcase
  end
end
