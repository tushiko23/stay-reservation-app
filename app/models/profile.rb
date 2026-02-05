class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :icon

  validates :icon, content_type: [ :png, :jpg, :jpeg ]
  accepts_nested_attributes_for :user
end
