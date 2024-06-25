defmodule GithubUserSearchAppWeb.ProfileLive do
  use GithubUserSearchAppWeb, :live_view

  alias GithubUserSearchApp.Profile.ProfileApi
  alias GithubUserSearchAppWeb.CustomComponent
  alias GithubUserSearchApp.Profile.ProfileChangeset
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="mx-auto text-white font-SpaceMono md:max-w-lg md:px-8 ">
      <div class="flex justify-between py-2">
        <h1 class="font-bold text-[#222731] dark:text-[#FFFFFF]">devfinder</h1>
        <button phx-click={toggle_dark_mode()} class="flex items-center gap-3 ">
          <div id="light-mode" class="flex gap-2 text-[#FFFFFF]">
            <span>light</span>
            <CustomComponent.sun_icon />
          </div>
          <div id="dark-mode" class="hidden ">
            <div class="flex gap-2 text-[#4B6A9B]">
              <span>dark</span>
              <CustomComponent.moon_icon />
            </div>
          </div>
        </button>
      </div>

      <CustomComponent.search_form form={@form} />

      <.profile profile={@profile} />
    </div>
    """
  end

  def profile(assigns) do
    ~H"""
    <div class="font-SpaceMono bg-[#FEFEFE] dark:bg-[#1E2A47]">
      <div class="p-6 rounded-lg">
        <div class="flex">
          <img src={@profile["avatar_url"]} alt={@profile["name"]} class="w-16 rounded-full" />
          <div class="pl-4">
            <div>
              <h2 class="font-bold text-[#2B3442] dark:text-[#FFFFFF]"><%= @profile["name"] %></h2>
              <span class="text-xs text-[#0079FF]" data-role="profile">
                @<%= @profile["login"] %>
              </span>
            </div>
            <p class="text-sm font-light text-[#697C9A] dark:text-[#FFFFFF]">
              <%= "Joined  #{format_date(@profile["created_at"])}" %>
            </p>
          </div>
        </div>
        <div class="">
          <p class="py-5 text-xs text-[#4B6A9B] dark:text-[#FFFFFF]"><%= @profile["bio"] %></p>

          <div class="flex space-x-6 items-center  bg-[#F6F8FF] dark:bg-[#141D2F] rounded-lg p-5 md:space-x-24">
            <CustomComponent.stats
              :for={
                {stats_description, stats} <- [
                  {"Repos", @profile["public_repos"]},
                  {"Followers", @profile["followers"]},
                  {"Following", @profile["following"]}
                ]
              }
              stats_description={stats_description}
              stats={stats}
            />
          </div>
          <div class="grid-cols-2 pt-5 space-y-3 text-xs md:grid text-[#4B6A9B] dark:text-[#FFFFFF]">
            <div class="flex">
              <CustomComponent.location_icon />
              <p class="items-center pl-3"><%= @profile["location"] %></p>
            </div>
            <div class="flex items-center ">
              <CustomComponent.twitter_icon account_exist?={@profile["twitter_username"]} />
              <p class="pl-3">
                <%= if(@profile["twitter_username"],
                  do: @profile["twitter_username"],
                  else: "not available") %>
              </p>
            </div>
            <div class="flex items-center">
              <CustomComponent.link_icon />
              <p class="pl-3">
                <%= if(@profile["blog"], do: @profile["blog"], else: "not available") %>
              </p>
            </div>
            <div class="flex items-center">
              <CustomComponent.office_icon />
              <p class="pl-3"><%= @profile["company"] %></p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    # profile = ProfileApi.data()

    {
      :ok,
      socket
      |> assign_user()
      # |> assign(profile: profile)
      |> assign_profile()
    }
  end

  def assign_profile(socket) do
    {:ok, profile} = ProfileApi.get_profile("octocat")
    IO.inspect(profile)
    assign(socket, :profile, profile)
  end

  def assign_user(socket) do
    form =
      ProfileChangeset.change_user()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event("toggle_theme", _unsigned_params, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"profile_changeset" => profile_changeset_params}, socket) do
    form =
      %ProfileChangeset{}
      |> ProfileChangeset.change_user(profile_changeset_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("search_dev", %{"profile_changeset" => params}, socket) do
    case ProfileApi.get_profile(params["username"]) do
      {:ok, profile} -> {:noreply, assign(socket, :profile, profile)}
      {:error, _reason} -> {:noreply, socket}
    end
  end

  def format_date(date) do
    {:ok, date, _} = DateTime.from_iso8601(date)

    date
    |> DateTime.to_date()
    |> Timex.format!("{D} {Mshort} {YYYY}")
  end

  def toggle_dark_mode do
    JS.dispatch("toggle-darkmode")
    |> JS.toggle(to: "#dark-mode", display: "flex")
    |> JS.toggle(to: "#light-mode", display: "flex")
  end
end
