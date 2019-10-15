module YariiEditor
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include YariiEditor::ControllerAuthorization

    before_action :set_content_model_base_path

    def set_content_model_base_path
      CurrentSite.setup
    end

    def current_site
      CurrentSite.site
    end
    helper_method :current_site
  end
end
