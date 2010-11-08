class AdminController < AlchemyController
  
  filter_access_to :index
  before_filter :set_translation
  
  layout 'alchemy'
  
  def index
    @alchemy_version = Alchemy.version
  end
  
  # Signup only works if no user is present in database.
  def signup
    flash[:explain] = _("Please Signup")
    if request.get?
      redirect_to admin_path if User.count != 0
      @user = User.new
    else
      @user = User.new(params[:user].merge({:role => 'admin'}))
      if @user.save
        if params[:send_credentials]
          Mailer.deliver_new_alchemy_user_mail(@user, request)
        end
        redirect_to :action => :index
      end
    end
  end
  
  def login
    if User.count == 0
      redirect_to :action => 'signup'
    else
      if request.get?
        @user_session = UserSession.new()
        flash.now[:info] = params[:message] || _("welcome_please_identify_notice")
        render :layout => 'login'
      else
        @user_session = UserSession.new(params[:user_session])
        if @user_session.save
          if session[:redirect_url].blank?
            redirect_to :action => :index
          else
            redirect_to session[:redirect_url]
          end
        else
          render :layout => 'login'
        end
      end
    end
  end
  
  def logout
    message = params[:message] || _("logged_out")
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end
    flash[:info] = message
    redirect_to root_url
  end
  
end
