class Report < ApplicationRecord
  belongs_to :car
  belongs_to :user
  has_one_attached :photo, dependent: :destroy
  validates :photo, presence: true
  validates :content, presence: true
  validates :report_type, presence: true
 private
 def validate_photo_filetype
  # Valida el formato del archivo adjunto
  if photo.attached? && !photo.content_type.in?(%w(image/jpeg image/png))
    errors.add(:photo, :bad_photo_type, type1: ".jpg", type2: ".png")
  end
end
end
