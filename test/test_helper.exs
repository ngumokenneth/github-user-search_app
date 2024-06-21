Mox.defmock(GithubUserSearchApp.Profile.Client.Mock, for: GithubUserSearchApp.Profile.Client)

Application.put_env(
  :github_user_search_app,
  :profile_api,
  GithubUserSearchApp.Profile.Client.Mock
)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(GithubUserSearchApp.Repo, :manual)
