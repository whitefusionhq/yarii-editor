module Yarii
  class Site < ApplicationRecord
    def self.table_name_prefix
      'yarii_'
    end

    def repository
      @repository ||= Yarii::Repository.new(git_repo_path)
    end

    def content_models
      return @content_models if @content_models

      yaml_path = File.join(git_repo_path, '.yarii', 'content_models.yml')
      if (File.exist?(yaml_path))
        @content_models = ::SafeYAML.load(File.open(yaml_path))
        @content_models = @content_models[Rails.env]&.with_indifferent_access
        if @content_models.nil?
          raise "No content models were found for the #{Rails.env} environment"
        end
        @content_models
      else
        raise "No content models YAML file was found at #{yaml_path}"
      end
    end

    def update_status_before_commit!
      well_known_path = File.join(content_base_path, '.well-known')
      unless Dir.exist?(well_known_path)
        Dir.mkdir(well_known_path)
      end
      status_path = File.join(content_base_path, '.well-known', 'yarii-status')
      File.open(status_path, 'w') do |f|
        update_digest = Digest::SHA256.hexdigest(Time.now.to_i.to_s)
        f.puts update_digest
      end
      repository.add(status_path)
      true
    end

    def commit!(message:)
      update_status_before_commit!
      repository.commit(message: message)
    end

    def push
      repository.push
    end

    def remote_is_up_to_date?
      # NOTE: the Jekyll site config needs to include .well-known in the list of
      # folders to build! Otherwise this won't work!
      status_path = File.join(content_base_path, '.well-known', 'yarii-status')
      if (File.exist?(status_path))
        update_digest = File.open(status_path).read.chomp
        published_status = Net::HTTP.get(URI(published_base_url + "/.well-known/yarii-status"))
        published_status.chomp == update_digest
      else
        false
      end
    end
  end
end
