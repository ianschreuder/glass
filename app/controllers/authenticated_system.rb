module AuthenticatedSystem
  protected

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= user_from_session unless @current_user == false
  end
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
  end
  def current_login
    @current_login ||= login_from_session unless @current_login == false
  end
  def current_login=(new_login)
    session[:login_id] = new_login ? new_login.id : nil
    @current_login = new_login || false
  end

  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights.
  def authorized?(action = action_name, resource = nil)
    return logged_in?
  end

  def login_required
    (logged_in? && authorized?) ? true : access_denied
  end

  def access_denied
    if logged_in?
      flash[:error] = "You don't have permission to perform that action."
    else
      flash[:error] = "You have to login to access that." unless request.fullpath=="/"
      session[:tokenized_request] = request.fullpath if request.fullpath.include?("token")
    end
    redirect_to("/login")
  end

  def user_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end
  def login_from_session
    self.current_login = Login.find_by_id(session[:login_id]) if session[:login_id]
  end

  # This is ususally what you want; resetting the session willy-nilly wreaks
  # havoc with forgery protection, and is only strictly necessary on login.
  # However, **all session state variables should be unset here**.
  def logout_keeping_session!
    session[:user_id] = nil
    session[:login_id] = nil
  end

  # The session should only be reset at the tail end of a form POST --
  # otherwise the request forgery protection fails. It's only really necessary
  # when you cross quarantine (logged-out to logged-in).
  def logout_killing_session!
    logout_keeping_session!
    reset_session
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :current_login, :logged_in?, :authorized? if base.respond_to? :helper_method
  end

end
