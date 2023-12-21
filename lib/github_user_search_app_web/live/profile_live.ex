defmodule GithubUserSearchAppWeb.ProfileLive do
  use GithubUserSearchAppWeb, :live_view
  alias GithubUserSearchApp.Profile.ProfileApi
  alias GithubUserSearchAppWeb.IconComponent

  def mount(_params, _session, socket) do
    # profile = ProfileApi.fetch("ngumokenneth")
    profile = ProfileApi.data()
    form = to_form(%{"username" => ""})
    {:ok, assign(socket, profile: profile, form: form)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-indigo-800 text-white py-10">
      <div>
        <h1>devfinder</h1>
      </div>

      <IconComponent.search_form form={@form} />

      <div class="flex py-6 px-10 mx-6 my-8 rounded-sm bg-[#1E2A47]">
        <div>
          <img src={@profile["avatar_url"]} alt="" class="rounded-full w-24" />
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
              <IconComponent.location_icon />
              <p><%= @profile["location"] %></p>
            </div>
            <div>
              <IconComponent.twitter_icon account_exist?={@profile["twitter_username"]} />
              <p><%= @profile["twitter_username"] %></p>
            </div>
            <div>
              <IconComponent.link_icon />
              <p><%= @profile["blog"] %></p>
            </div>
            <div>
              <IconComponent.office_icon />
              <p><%= @profile["company"] %></p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("search_user", %{"username" => username}, socket) do
    case ProfileApi.fetch(username) do
      {:ok, user} ->
        form = to_form(%{"username" => ""})
        socket = put_flash(socket, :info, "user profile fetched success")
        {:noreply, assign(socket, user: user, form: form)}

      {:error, error} ->
        form = to_form(%{"username" => ""})
        socket = put_flash(socket, :error, error)
        {:noreply, assign(socket, form: form)}
    end
  end
end
