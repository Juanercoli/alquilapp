class Car < ApplicationRecord
  # Imagen del autos
  has_one_attached :photo, dependent: :destroy
  # Validaciones a nivel base de datos
  validates :brand, presence: true
  validates :color, presence: true
  validates :patent, presence: true, uniqueness: true
  validates :vehicle_number, presence: true, uniqueness: true
  validates :model, presence: true
  validates :photo, presence: true
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
end
