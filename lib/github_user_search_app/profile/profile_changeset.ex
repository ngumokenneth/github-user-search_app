defmodule GithubUserSearchApp.Profile.ProfileChangeset do
  import Ecto.Changeset
  alias GithubUserSearchApp.Profile.ProfileChangeset

  defstruct [:username]
  @types %{username: :string}
  def validate_username(%__MODULE__{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:username])
  end

  def change_user(user \\ %__MODULE__{}, attrs \\ %{}) do
    ProfileChangeset.validate_username(user, attrs)
  end
end
