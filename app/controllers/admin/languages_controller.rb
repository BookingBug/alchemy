class Admin::LanguagesController < AlchemyController
  
  filter_resource_access
  before_filter :set_translation
  
  def index
    if !params[:query].blank?
      @languages = Language.all(
        :conditions => [
          "languages.name LIKE ? OR languages.code = ? OR languages.frontpage_name LIKE ?",
          "%#{params[:query]}%",
          "#{params[:query]}",
          "%#{params[:query]}%"
        ]
      )
    else
      @languages = Language.all
    end
  end
  
  def new
    @language = Language.new
    render :layout => false
  end
  
  def edit
    render :layout => false
  end
  
  def create
    @language = Language.new(params[:language])
    @language.save
    render_errors_or_redirect(
      @language,
      admin_languages_path,
      ( _("Language '%{name}' created") % {:name => @language.name} )
    )
  end
  
  def update
    @language.update_attributes(params[:language])
    render_errors_or_redirect(
      @language,
      admin_languages_path,
      ( _("Language '%{name}' updated") % {:name => @language.name} )
    )
  end
  
  def destroy
    name = @language.name
    @language.destroy
    flash[:notice] = ( _("Language '%{name}' destroyed") % {:name => name} )
    render(:update) { |page| page.redirect_to(admin_languages_url) }
  end
  
private
  
  def find_language
    @language = Language.find(params[:id])
  end
  
end
