class Location < ActiveRecord::Base

  belongs_to :user

  def distance(other)
    return nil unless lat && lng && other.lat && other.lng
    radius = 6371; # (km)
    d_lat = (other.lat - self.lat).degrees
    d_lng = (lng - lng).degrees
    a = Math.sin(d_lat/2.0)*Math.sin(d_lat/2.0) + Math.cos(lat.degrees)*Math.cos(other.lat.degrees)*Math.sin(d_lng/2.0)*Math.sin(d_lng/2.0)
    radius * (2*Math.atan2(Math.sqrt(a), Math.sqrt(1-a)))
  end

end