class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_create :change_status_to_host
  before_destroy :change_status_to_not_host

  def average_review_rating
    self.reviews.inject(0.0) {|sum, review| sum + review.rating} / self.reviews.count.to_f
  end

  private

  def change_status_to_host
    self.host.update(host: true)
  end

  def change_status_to_not_host
    
    if self.host.listings.size == 1
      self.host.update(host: false)
    end
  end

  


end
