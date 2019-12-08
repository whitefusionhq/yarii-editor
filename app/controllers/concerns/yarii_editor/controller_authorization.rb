module YariiEditor
  module ControllerAuthorization
    extend ActiveSupport::Concern

    included do
      before_action :check_if_yarii_is_authorized
    end

    def check_if_yarii_is_authorized
      yarii_user = YariiEditor::CurrentUser.from_controller(self)
      unless yarii_user&.can_access_yarii?
        raise YariiEditor::NotAuthorizedError
      end
    end
  end
end
