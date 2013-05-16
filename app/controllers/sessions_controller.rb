class SessionsController < ApplicationController
  include SessionMethods

  skip_before_action :login_required, :only => [:new, :create]

  def new
    render(:layout=>false)
  end

  def create
    logout_keeping_session!
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      start_new_session(user)
      redirect_to("/")
    else
      @email = params[:email]
      flash[:error] = "Could not log you in."
      redirect_to("/login")
    end
  end

  def destroy
    logout_keeping_session!
    session[:token] = nil # only place we can do this one
    redirect_to("/login")
  end

end
