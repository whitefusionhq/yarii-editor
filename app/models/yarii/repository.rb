require 'git'

class Yarii::Repository
  attr_accessor :repo_dir, :git

  def initialize(repo_dir)
    # TODO: allow passing in a list of ignored files for determining changes
    @repo_dir = repo_dir
    @git = Git.open(@repo_dir)
  end

  def changes?
    git_diff = @git.lib.diff_index('HEAD').values
    if git_diff.present?
      return true unless git_diff.length == 1 && git_diff.first[:path].to_s.include?("Procfile")
    end

    false

# NOTE: THIS CODE IS TOO SLOW! keeping for future reference
#
#    changed_files = @git.status.changed

    # don't include small changes to _site only, such as feed.xml, etc.
#    changed = changed_files.length - changed_files.keys.select{|item| item.include?('_site/')}.length

#    added = @git.status.added.length
#    deleted = @git.status.deleted.length

#    (changed + added + deleted) > 0
  end

  def add(filepath)
    @git.add(filepath)
  end

  def remove(filepath)
    @git.remove(filepath)
  end

  def pull(remote: nil)
    if remote
      @git.pull @git.remote(remote)
    else
      @git.pull
    end
  end

  def needs_pull?
    @git.fetch(ENV['git_publish_remote'] || 'origin')
    gitstatus = `cd "#{@repo_dir}";git status`
    gitstatus.include? "branch is behind"
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