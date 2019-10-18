class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validate :check_accepted, :reservation_passed

  private

  def check_accepted
    if  self.reservation && self.reservation.status != "accepted" 
      errors.add(:checkin, "Reservation must be accepted ")
    end
  end

  def reservation_passed
    if self.reservation && self.reservation.checkout && self.reservation.checkout > Date.today
      errors.add(:checkin, "Reservation must be checked out")
    end
  end

end