class Car < ApplicationRecord
  has_many :rental, dependent: :destroy
  has_many :fine, dependent: :destroy
  has_many :car_usage_history, dependent: :destroy
  # Imagen del autos
  has_one_attached :photo, dependent: :destroy
  # Validaciones a nivel base de datos
  validates :brand, presence: true
  validates :color, presence: true
  validates :patent, presence: true, uniqueness: true
  validate :validate_patent_argentina
  validates :vehicle_number, presence: true, uniqueness: true
  validates :model, presence: true
  validates :photo, presence: true
  validate :validate_photo_filetype
  # Callback antes de guardar
  before_save :downcase_attributes

  private
  
  def downcase_attributes
    # Pasamos los atributos a minúsculas por convención propia
    self.brand = brand.downcase
    self.color = color.downcase
    self.patent = patent.downcase
    self.model = model.downcase
  end

  def validate_photo_filetype
    # Valida el formato del archivo adjunto
    if photo.attached? && !photo.content_type.in?(%w(image/jpeg image/png))
      errors.add(:photo, :bad_photo_type, type1: ".jpg", type2: ".png")
    end
  end

  def validate_patent_argentina
    # 3 letras y 3 números
    old_patent_regex = /\A[a-zA-Z]{3}[\d]{3}\z/
    # 2 letras, 3 números y 2 letras
    new_patent_regex = /\A[a-zA-Z]{2}[\d]{3}[a-zA-Z]{2}\z/
    # Si el formato es válido hay match
    is_valid = patent.match(old_patent_regex) || patent.match(new_patent_regex)

    is_valid ? true : errors.add(:patent, :bad_patent_type)
  end
end
