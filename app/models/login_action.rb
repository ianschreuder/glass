class LoginAction < ActiveRecord::Base
  belongs_to :login
  belongs_to :user

end