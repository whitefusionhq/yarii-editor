module YariiEditor
  module ModelCallbacks
    extend ActiveSupport::Concern

    included do
      after_save :add_to_repository_index
      around_destroy :remove_from_repository
    end

    def add_to_repository_index
      if persisted?
        CurrentSite.site&.repository&.add(absolute_path_in_source_dir)
        CurrentSite.site&.build_preview
      end
    end

    def remove_from_repository
      if persisted?
        past_file_path = absolute_path_in_source_dir
        yield
        CurrentSite.site&.repository&.remove(past_file_path)
        CurrentSite.site&.build_preview
      end
    end
  end
end