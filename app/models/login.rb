class Login < ActiveRecord::Base
  belongs_to :user
  has_many :login_actions, :dependent => :destroy

end