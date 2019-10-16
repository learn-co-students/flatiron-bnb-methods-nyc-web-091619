class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  validates :checkin, :checkout, presence: true
  validate :val_available, :val_checkin_checkout, :val_not_yours

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

  private 

  def val_available
    if !self.checkin || !self.checkout
      errors.add(:checkin, "Checkin and Checkout cannot be blank")
      return
    end

    overlap = self.listing.reservations.find do |res| 
      self.checkin <= res.checkout && self.checkout >= res.checkin
    end

    if overlap
      errors.add(:checkin, "Checkin and Checkout cannot overlap with other reservation")
    end
   
  end

  def val_checkin_checkout
    if !self.checkin || !self.checkout
      errors.add(:checkin, "Checkin and Checkout cannot be blank")
      return
    end

    if self.checkin == self.checkout
      errors.add(:checkin, "Checkin cannot be the same as checkout")
    end 
    if self.checkin > self.checkout
      errors.add(:checkin, "Checkin must be before checkout")
    end

  end
 
  #   validates that you cannot make a reservation on your own listing (FAILED - 4)
  def val_not_yours
    if self.guest == self.listing.host
      errors.add(:guest, "Guest cannot be the host")
    end
  end

end
