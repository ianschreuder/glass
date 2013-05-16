class User < ActiveRecord::Base
  has_secure_password
  has_many :logins, :dependent=>:destroy
  has_many :login_actions, :dependent=>:destroy

  default_scope { where("deleted_at is null") }

  validates :password, :length=>{:minimum=>8}, :allow_blank=>true # some users are just friends of real users and aren't registered
  validates :email, :email => true, :allow_blank=>true
  
  before_save :force_downcases, :set_time_zone

  def admin?; self.admin == YES end

  private

  def force_downcases
    self.email = self.email.try(:downcase)
  end

  def set_time_zone
    self.time_zone = "America/Denver" if time_zone.blank?
  end

end
