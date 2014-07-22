class AddOauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_facebook, :string
    add_column :users, :oauth_google, :string
    add_column :users, :oauth_twitter, :string
    add_column :users, :oauth_github, :string
  end
end
