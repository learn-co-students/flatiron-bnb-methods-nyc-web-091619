class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_str, end_str)
    #Not (A Or B) <=> Not A And Not B
    #(StartA <= EndB)  and  (EndA >= StartB)
    check_start = Date.parse(start_str)
    check_end = Date.parse(end_str)
    self.listings.select do |listing| 
      listing.reservations.all? { |res| !(res.checkin <= check_end && res.checkout >= check_start)}
    end
    
  end

  def self.highest_ratio_res_to_listings
    #return city with higest # of reservations per listing
    best_avg = 0
    best_neighborhood = nil
    self.all.each do |neighborhood|
      res_count = neighborhood.listings.map {|listing| listing.reservations.count}
      avg = res_count.inject{ |sum, count| sum + count }.to_f / res_count.size
      if avg > best_avg
        best_avg = avg
        best_neighborhood = neighborhood 
      end
    end

    best_neighborhood

  end

  def get_reservations
    self.listings.map {|listing| listing.reservations}.flatten
  end

  def self.most_res
 
    self.all.max_by {|neighborhood| neighborhood.get_reservations.count}
  
  end

end