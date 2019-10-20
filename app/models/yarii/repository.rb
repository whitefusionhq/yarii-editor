require 'git'

class Yarii::Repository
  attr_accessor :repo_dir, :git

  Changeset = Struct.new(:total, :added, :modified, :deleted, keyword_init: true)

  def initialize(repo_dir)
    @repo_dir = repo_dir
    @git = Git.open(@repo_dir)
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
    if remote
      @git.pull @git.remote(remote)
    else
      @git.pull
    end
  end

  def needs_pull?(remote: nil)
    if remote
      @git.fetch @git.remote(remote)
    else
      @git.fetch
    end
    @git.lib.diff_name_status('HEAD','@{upstream}').length > 0
  end

  def commit(message:)
    @git.commit(message)
  end

  def push(remote: nil)
    if remote
      @git.push @git.remote(remote)
    else
      @git.push
    end
  end
end