defmodule GithubUserSearchApp.Repo do
  use Ecto.Repo,
    otp_app: :github_user_search_app,
    adapter: Ecto.Adapters.Postgres
end
