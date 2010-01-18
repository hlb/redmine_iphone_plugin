class IphoneController < ApplicationController

  unloadable
  layout "iphone"

  def index
    @projects = Project.all User.current
    @assigned_issues = Issue.visible.open.find(:all,
                                    :conditions => {:assigned_to_id => User.current.id},
                                    :include => [ :status, :project, :tracker, :priority ],
                                    :order => "#{IssuePriority.table_name}.position DESC, #{Issue.table_name}.updated_on DESC")
  end

  def login
    if request.get?
      # Logout user
      self.logged_user = nil
    else
      password_authentication
    end
  end

  def successful_authentication(user)
    # Valid user
    self.logged_user = user
    # generate a key and set cookie if autologin
    if params[:autologin] && Setting.autologin?
      token = Token.create(:user => user, :action => 'autologin')
      cookies[:autologin] = { :value => token.value, :expires => 1.year.from_now }
    end
    call_hook(:controller_account_success_authentication_after, {:user => user })
    render :action => 'redirect', :layout => false
  end

  def invalid_credentials
    flash.now[:error] = l(:notice_account_invalid_creditentials)
  end

  def password_authentication
    user = User.try_to_login(params[:username], params[:password])

    if user.nil?
      invalid_credentials
    else
      # Valid user
      successful_authentication(user)
    end
  end
end
