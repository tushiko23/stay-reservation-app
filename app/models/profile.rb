class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :icon

  accepts_nested_attributes_for :user
end
