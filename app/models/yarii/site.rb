module Yarii
  class Site < ApplicationRecord
    def self.table_name_prefix
      'yarii_'
    end

    def repository
      @repository ||= Yarii::Repository.new(git_repo_path)
    end
  end
end
