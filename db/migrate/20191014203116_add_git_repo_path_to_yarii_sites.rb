class AddGitRepoPathToYariiSites < ActiveRecord::Migration[6.0]
  def change
    add_column :yarii_sites, :git_repo_path, :string
  end
end
