module YariiEditor
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :set_content_model_base_path

    def set_content_model_base_path
      SitePath.setup
    end

    def current_site
      SitePath.current_site
    end
    helper_method :current_site
  end
end
