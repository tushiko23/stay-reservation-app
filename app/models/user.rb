class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :reserved_rooms, through: :reservations, source: :room
  validates :name, presence: { message: "を入力してください" }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
