class Admin::AdminController < ApplicationController

  def authorized
    current_user.try(:admin?)
  end


end
