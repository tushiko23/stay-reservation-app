class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :check_in_date, presence: true
  validates :check_out_date, presence: true
  validates :guest_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :date_cannot_be_in_the_past
  validate :check_out_date_after_check_in_date

  def date_cannot_be_in_the_past
    return if check_in_date.blank?
    if check_in_date < Date.today
      errors.add(:check_in_date, "は本日以降の日付を選択してください")
    end
  end

  def check_out_date_after_check_in_date
    return if check_out_date.blank? || check_in_date.blank?
    if check_out_date <= check_in_date
      errors.add(:check_out_date, "はチェックイン日より後の日付を選択してください")
    end
  end

  def stay_days
    @stay_days = (check_out_date - check_in_date).to_i
  end

  def calculate_total_price
    stay_days
    room.fee_per_day * @stay_days * guest_count
  end
end
