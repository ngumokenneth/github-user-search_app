defmodule GithubUserSearchAppWeb.ProfileLiveTest do
  use GithubUserSearchAppWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders profile html", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/profile")

    assert render(view) =~ "devfinder"
  end

  # test "renders profile avatar", %{conn: conn} do
  #   avatar_url = "https://avatars.githubusercontent.com/u/1234567?v=4"
  #   {:ok, view, _html} = live(conn, ~p"/profile")

  #   avatar = element(view, "img[src*=\"#{avatar_url}\"]")
  #   assert has_element?(avatar)
  # end

  test "user can submit form", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/profile")

    view
    |> form("#search_form", %{profile_changeset: %{username: "ngumokenneth"}})
    |> render_submit()

    assert has_element?(view, data - role = "profile", username: "ngumokenneth")

    # html =
    #   view
    #   |> form("#search_form", %{profile_changeset: %{username: "ngumokenneth"}})
    #   |> render_submit()

    # assert html =~ "ngumokenneth"
  end

  test "validates user input", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/profile")

    html = view |> form("#validate", %{profile_changeset: %{username: ""}}) |> render_submit()
    assert html =~ "can't be blank"
  end
end
