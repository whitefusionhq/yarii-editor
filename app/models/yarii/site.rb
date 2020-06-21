module Yarii
  class Site < ApplicationRecord
    def self.table_name_prefix
      'yarii_'
    end

    def bridgetown
      @bridgetown ||= Dir.chdir(Pathname.new(content_base_path).parent) do
        Bridgetown::Site.setup_and_read(limit_posts: 0, unpublished: true, future: true)
      end
    end

    def repository
      @repository ||= Yarii::Repository.new(git_repo_path)
    end

    def content_models
      return @content_models if @content_models

      yaml_path = Pathname.new(content_base_path).parent.join('.yarii', 'content_models.yml')
      if (File.exist?(yaml_path))
        @content_models = ContentModels.new(self, yaml_path)
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

      post_push_path = File.join(git_repo_path, '.git', 'hooks', 'post-push')
      if File.exist?(post_push_path)
        Bundler.with_clean_env do
          trap('SIGINT') { exit }
          puts "*** Executing post push hook"
          output = system("#{ENV["SHELL"]} --login -c \"cd #{git_repo_path} && #{post_push_path}\"")  
        end
      end
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

    def preview_build_command
      if "preview_build_command".in?(self.class.columns.map(&:name))
        attributes["preview_build_command"]
      else
        'bundle exec jekyll build --unpublished'
      end
    end

    def build_preview
      Bundler.with_clean_env do
        trap('SIGINT') { exit }
        puts "*** Building Preview Site: #{title}"
        output = system("#{ENV["SHELL"]} --login -c \"cd #{git_repo_path} && #{preview_build_command}\"")  
      end
    end
  end
end

Bridgetown::ContentModel.class_eval do
  include YariiEditor::ModelCallbacks

  def will_be_published?
    return false if respond_to?(:published) and published === false
    return false if respond_to?(:draft) and draft
    true
  end
end
