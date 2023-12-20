defmodule GithubUserSearchAppWeb.ProfileLive do
  use GithubUserSearchAppWeb, :live_view

  def mount(_params, _session, socket) do
    # profile = fetch("ngumokenneth")
    profile = data()
    {:ok, assign(socket, :profile, profile)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-indigo-800 text-white py-10">
      <div>
        <h1>devfinder</h1>
      </div>
      <div class="flex">
        <.input type="text" value="" name="name" placeholder="Search Github Username" phx-change="search">
        </.input>
        <.button phx-click="submit" class="">search</.button>
      </div>
      <div class="flex py-6 px-10 mx-6 my-8 rounded-sm bg-[#1E2A47]">
        <div >
          <img src={@profile["avatar_url"]}  alt="" class="rounded-full w-24">
        </div>
        <div class="ml-6">
          <div class="flex justify-between">
            <div>
              <h2 class="font-bold"><%= @profile["name"] %></h2>
              <span class=" flex block text-xs">@<%= @profile["login"] %></span>
            </div>
            <p class="text-sm"><%= @profile["created_at"] %></p>
          </div>
          <p class="my-4 text-xs"><%= @profile["bio"] %></p>
          <div class="flex justify-between bg-[#141D2F] rounded-lg my-8 px-6 py-2">
            <div>
              <p class="text-xs">Repos</p>
              <span><%= @profile["public_repos"] %></span>
            </div>
            <div>
              <p class="text-xs">Followers</p>
              <span><%= @profile["public_repos"] %></span>
            </div>
            <div>
              <p class="text-xs">Following</p>
              <span><%= @profile["following"] %></span>
            </div>
          </div>
          <div class="grid grid-cols-2 text-xs">
            <div>
            <%!-- <.icon name="hero-map-solid" /> --%>
            <p><%= @profile["location"] %></p>
            </div>
            <div>
            <p><%= @profile["twitter_username"] %></p>
            </div>
            <div>
            <p><%= @profile["blog"] %></p>
            </div>
            <div>
            <p><%= @profile["company"] %></p>
            </div>
          </div>
      </div>
      </div>
    </div>
    """
  end

  def fetch(username) do
    response = Finch.build(:get, "https://api.github.com/users/#{username}")

    case Finch.request(response, GithubUserSearchApp.Finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        handle_response(body, 200)

      {:ok, %Finch.Response{status: status, body: body}} ->
        handle_response(body, status)

      {:error, request_fail} ->
        IO.inspect(request_fail, label: "request error")
    end
  end

  def handle_response(body, status) do
    case Jason.decode(body) do
      {:ok, user} when status == 200 -> user
      {:error, user_error} -> IO.puts(user_error["message"])
    end
  end

  def handle_event("search", %{"username" => username}, socket) do
    user = __MODULE__.fetch(username)

    {:noreply, assign(socket, :user, user)}
  end
  def handle_event("submit", %{"username" => username}, socket) do
    user = __MODULE__.fetch(username)
    {:noreply, assign(socket, :user, user)}
  end

  def data do
    %{
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
      "twitter_username" => "ngumo_kenneth",
      "type" => "User",
      "updated_at" => "2023-12-18T19:05:45Z",
      "url" => "https://api.github.com/users/ngumokenneth"
    }
  end
end
