module YariiEditor
  module ControllerAuthorization
    extend ActiveSupport::Concern

    included do
      before_action :check_if_yarii_is_authorized
      
      rescue_from YariiEditor::NotAuthorizedError, with: :handle_yarii_authorization_failure
    end

    def check_if_yarii_is_authorized
      yarii_user = YariiEditor::CurrentUser.from_controller(self)
      unless yarii_user&.can_access_yarii?
        raise YariiEditor::NotAuthorizedError
      end
    end
    
    def handle_yarii_authorization_failure
      render plain: "503 Not Authorized", status: 503
    end
  end
end
