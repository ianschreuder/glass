class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :login_required
  before_action :check_user_info
  after_action :update_login_actions

  if Rails.env == "production"
    rescue_from Exception, :with => :low_level_exception_handler
  end

  def check_user_info
    return if current_user.blank? || current_user.number.present?
    flash[:notice] = 'We need your phone number for this application.'
    redirect_to edit_user_path(current_user)
  end

  def update_login_actions
    return if !current_user || !current_login || Rails.env=="test"
    s = LoginAction.new(:user=>current_user, :login=>current_login)
    s.uri = request.env["REQUEST_URI"].try(:truncate,300)
    s.save
  end

  def low_level_exception_handler(exception)
    flash.now[:error] = "An unexpected error occurred.  We have been notified of the issue and are working on resolving it."
    begin
      SystemMailer.exception(self, request, exception).deliver
    rescue Exception => e
      logger.error("###Email exception: #{e.message}\n #{e.backtrace.join('\n')}")
      logger.error("###\nCouldn't deliver e-mail for exception => #{exception.message}\n#{exception.backtrace.join("\n")}\n")
    end
    (self.controller_name == 'dash' && self.action_name == 'index') ? redirect_to("/500.html") : redirect_to("/")
  end

end
