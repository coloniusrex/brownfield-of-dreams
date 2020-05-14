class AddGithubIDtoUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_id, :string
  end
end
