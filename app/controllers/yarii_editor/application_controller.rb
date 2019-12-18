module YariiEditor
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include YariiEditor::ControllerAuthorization
    include YariiEditor::RepositoryPullable

    before_action :set_content_model_base_path

    def set_content_model_base_path
      if session[:current_yarii_site]
        CurrentSite.setup(Yarii::Site.find(session[:current_yarii_site]))
      else
        CurrentSite.setup
      end
    end

    def current_site
      CurrentSite.site
    end
    helper_method :current_site
  end
end
