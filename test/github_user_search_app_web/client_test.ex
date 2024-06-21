defmodule GithubUserSearchAppWeb.ClientTest do
  use ExUnit.Case, async: true
  import Mox

  alias GithubUserSearchAppWeb.Client

  setup :verify_on_exit!

  @valid_response %{
    "avatar_url" => "https://avatars.githubusercontent.com/u/61971501?v=4",
    "bio" => "I'm a full stack Elixir developer. Keen to good code and definitely good design.",
    "blog" => "www.ken.blog",
    "company" => "Optimum BH",
    "created_at" => "2020-03-09T11:17:43Z",
    "email" => nil,
    "events_url" => "https://api.github.com/users/ngumokenneth/events{/privacy}",
    "followers" => 1,
    "followers_url" => "https://api.github.com/users/ngumokenneth/followers",
    "following" => 6,
    "following_url" => "https://api.github.com/users/ngumokenneth/following{/other_user}",
    "gists_url" => "https://api.github.com/users/ngumokenneth/gists{/gist_id}",
    "gravatar_id" => "",
    "hireable" => nil,
    "html_url" => "https://github.com/ngumokenneth",
    "id" => 61_971_501,
    "location" => "Nairobi",
    "login" => "ngumokenneth",
    "name" => "ngumo kenneth",
    "node_id" => "MDQ6VXNlcjYxOTcxNTAx",
    "organizations_url" => "https://api.github.com/users/ngumokenneth/orgs",
    "public_gists" => 0,
    "public_repos" => 17,
    "received_events_url" => "https://api.github.com/users/ngumokenneth/received_events",
    "repos_url" => "https://api.github.com/users/ngumokenneth/repos",
    "site_admin" => false,
    "starred_url" => "https://api.github.com/users/ngumokenneth/starred{/owner}{/repo}",
    "subscriptions_url" => "https://api.github.com/users/ngumokenneth/subscriptions",
    "twitter_username" => nil,
    "type" => "User",
    "updated_at" => "2023-12-18T19:05:45Z",
    "url" => "https://api.github.com/users/ngumokenneth"
  }

  describe "fetch/1" do
    test "get user profile" do
      expect(GithubUserSearchApp.Profile.Client.Mock, :get_profile, fn _username ->
        {:ok, @valid_response}
      end)
    end
  end
end
