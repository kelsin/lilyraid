class LoginController < ApplicationController
    skip_before_filter :authorize

    def index
        # We don't, so we need to check for a sid param
        session_id = params[:sid]

        if session_id
            # We are logged into php2bb, let's get their info
            session[:account_id] = Account.get_account_id_from_sid(session_id)
            
            if session[:account_id]
                Account.get_account_from_id(session[:account_id]).update_info
                
                redirect_to(:controller => 'raids', :action=> 'index')
            else
                flash[:notice] = "Login Failed"
                logout
            end
        end
    end

    def login
        password = params[:password]
        username = params[:username]

        session[:account_id] = Account.get_account_id_from_info(username, password)

        if session[:account_id]
            Account.get_account_from_id(session[:account_id]).update_info
            
            redirect_to(:controller => 'raids', :action=> 'index')
        else
            flash[:notice] = "Login Failed"
            logout
        end
    end

    def logout
        reset_session
        redirect_to(:action => 'index')
    end
end
