class Room < ApplicationRecord
  belongs_to :user

  has_many :reservations, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true
  validates :introduction, presence: true
  validates :fee_per_day, presence: true
  validates :address, presence: true

  validates :fee_per_day, numericality: {
    greater_than: 0,
    only_integer: true
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[name introduction address]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
