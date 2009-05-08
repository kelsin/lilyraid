class LoginController < ApplicationController
  skip_before_filter :authorize

  def index
    if CONFIG[:auth] == 'phpbb'
      # Check for cookie
      session_id = cookies[CONFIG[:phpbb_cookie]]

      if session_id
        # We are logged into phpbb, let's get their info
        session[:account_id] = Account.get_account_id_from_sid(session_id)

        if session[:account_id] and session[:account_id].to_i != 1
          Account.get_account_from_id(session[:account_id]).update_info
          redirect_to(:controller => 'raids', :action=> 'index')
        else
          reset_session
        end
      end
    elsif CONFIG[:auth] == 'login'
      # Nothing to do here, they have to fill out the forum and hit the create action
    end
  end

  def create
    password = params[:password]
    username = params[:username]

    session[:account_id] = Account.get_account_id_from_info(username, password)

    if session[:account_id]
      redirect_to(:controller => 'raids', :action=> 'index')
    else
      reset_session
      flash[:notice] = "Login Failed"
      redirect_to(:action => 'index')
    end
  end

  def logout
    reset_session
    redirect_to(:action => 'index')
  end
end
