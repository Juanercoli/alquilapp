class Car < ApplicationRecord
  # Imagen del autos
  has_one_attached :photo, dependent: :destroy
  # Validaciones a nivel base de datos
  validates :brand, presence: true
  validates :color, presence: true
  validates :patent, presence: true, uniqueness: true,
    format: {
      with: /\A([A-Z]{2,3}[0-9]{3}[A-Z]{0,2})?\z/,
      message: 'tiene que ser en formato AAA111 o AA11AA'
  }
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
end
