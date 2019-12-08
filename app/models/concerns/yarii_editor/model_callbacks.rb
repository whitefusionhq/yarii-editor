module YariiEditor
  module ModelCallbacks
    extend ActiveSupport::Concern

    included do
      after_save :add_to_repository_index
      around_destroy :remove_from_repository
    end

    def add_to_repository_index
      if persisted?
        CurrentSite.site&.repository&.add(file_path)
        CurrentSite.site&.build_preview
      end
    end

    def remove_from_repository
      if persisted?
        past_file_path = file_path
        yield
        CurrentSite.site&.repository&.remove(past_file_path)
        CurrentSite.site&.build_preview
      end
    end
  end
end