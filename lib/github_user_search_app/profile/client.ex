defmodule GithubUserSearchApp.Profile.Client do
  alias GithubUserSearchApp.Profile.ProfileApi

  @callback get_profile(String.t()) ::
              {:ok, map()} | {:ok, String.t()} | {:error, String.t()}

  def fetch(username), do: impl().fetch(username)

  defp impl do
    Application.get_env(
      :github_user_search_app,
      :profile_api,
      ProfileApi
    )
  end
end
