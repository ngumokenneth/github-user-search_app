defmodule GithubUserSearchAppWeb.ClientTest do
  use ExUnit.Case, async: true
  import Mox

  alias GithubUserSearchAppWeb.Client
  alias GithubUserSearchApp.Profile.ProfileApi
  setup :verify_on_exit!

  @valid_response %{
    "avatar_url" => "https://avatars.githubusercontent.com/u/583231?v=4",
    "bio" => nil,
    "blog" => "https://github.blog",
    "company" => "@github",
    "created_at" => "2011-01-25T18:44:36Z",
    "email" => nil,
    "events_url" => "https://api.github.com/users/octocat/events{/privacy}",
    "followers" => 13953,
    "followers_url" => "https://api.github.com/users/octocat/followers",
    "following" => 9,
    "following_url" => "https://api.github.com/users/octocat/following{/other_user}",
    "gists_url" => "https://api.github.com/users/octocat/gists{/gist_id}",
    "gravatar_id" => "",
    "hireable" => nil,
    "html_url" => "https://github.com/octocat",
    "id" => 583231,
    "location" => "San Francisco",
    "login" => "octocat",
    "name" => "The Octocat",
    "node_id" => "MDQ6VXNlcjU4MzIzMQ==",
    "organizations_url" => "https://api.github.com/users/octocat/orgs",
    "public_gists" => 8,
    "public_repos" => 8,
    "received_events_url" => "https://api.github.com/users/octocat/received_events",
    "repos_url" => "https://api.github.com/users/octocat/repos",
    "site_admin" => false,
    "starred_url" => "https://api.github.com/users/octocat/starred{/owner}{/repo}",
    "subscriptions_url" => "https://api.github.com/users/octocat/subscriptions",
    "twitter_username" => nil,
    "type" => "User",
    "updated_at" => "2024-06-22T11:23:40Z",
    "url" => "https://api.github.com/users/octocat"
  }

  describe "fetch/1" do
    test "get user profile" do
      expect(GithubUserSearchApp.Profile.Client.Mock, :get_profile, fn _username ->
        {:ok, @valid_response}
      end)

      assert {:ok, @valid_response} = ProfileApi.get_profile("octocat")
    end
  end
end
