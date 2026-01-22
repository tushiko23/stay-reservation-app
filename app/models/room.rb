class Room < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, presence: true
  validates :introduction, presence: true
  validates :fee_per_day, presence: true
  validates :address, presence: true

  validates :fee_per_day, numericality: {
    greater_than: 0,
    only_integer: true
  }
end
