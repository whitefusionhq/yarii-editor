module YariiEditor
  module CurrentUser
    thread_mattr_accessor :user

    def self.from_controller(controller)
      self.user = controller.current_user
    end
    
    def self.reset
      self.user = nil
    end
  end
end
