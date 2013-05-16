# since we allow logins from three different controllers, i'm making a module out of the common login methods
module SessionMethods
  
  def start_new_session(user)
    return if user.blank? || user.id.blank?
    self.current_user = user
    return if session[:sudo]

    login = Login.create(:user=>current_user, :user_agent=>request.env["HTTP_USER_AGENT"], :remote_addr=>request.env["REMOTE_ADDR"], :referer=>request.env["HTTP_REFERER"])
    # delete all but last 5 logins
    Login.destroy(Login.find_by_sql("select id from logins where id < (select min(id) from (select id from logins where user_id = #{current_user.id} order by id desc limit 5) y)"))
    self.current_login=(login)
  end

end