module YariiEditor
  module RepositoryPullable
    extend ActiveSupport::Concern

    def pull_if_needed
      if current_site.repository.needs_pull?
        current_site.repository.pull
      end
    end
  end
end
