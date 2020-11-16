require 'git'

module Yarii
  class Repository
    attr_accessor :repo_dir, :git, :remote, :branch

    Changeset = Struct.new(:total, :added, :modified, :deleted, keyword_init: true)

    def initialize(repo_dir)
      @repo_dir = repo_dir
      @git = Git.open(@repo_dir)
      @remote = "origin"
      @branch = @git.current_branch
    end

    def add(filepath)
      @git.add(filepath)
    end

    def remove(filepath)
      @git.remove(filepath)
    end

    def changes(only_indexed: true)
      indexed_flag = only_indexed ? '--cached' : nil
      git_diff = @git.lib.diff_name_status('HEAD', indexed_flag)
      Changeset.new(
        total: git_diff.length,
        added: git_diff.select{|k,v| v == 'A'}.keys,
        modified: git_diff.select{|k,v| v == 'M'}.keys,
        deleted: git_diff.select{|k,v| v == 'D'}.keys
      )
    end

    def pull(remote: nil)
      @git.pull(@remote || remote, @branch)
    end

    def needs_pull?(remote: nil)
      @git.fetch(@remote || remote)
      @git.lib.diff_name_status('HEAD','@{upstream}').length > 0
    rescue Git::GitExecuteError => e
      Rails.logger.warn("Encountered a Git error while pulling: #{e.message}")
      false
    end

    def commit(message:)
      @git.commit(message)
    end

    def push(remote: nil)
      @git.push(@remote || remote, @branch)
    end
  end
end