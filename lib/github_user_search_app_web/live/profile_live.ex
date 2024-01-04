defmodule GithubUserSearchAppWeb.ProfileLive do
  use GithubUserSearchAppWeb, :live_view
  alias GithubUserSearchApp.Profile.ProfileApi
  alias GithubUserSearchAppWeb.CustomComponent
  alias GithubUserSearchApp.Profile.ProfileChangeset

  def mount(_params, _session, socket) do
    # profile = ProfileApi.fetch("ngumokenneth")
    profile = ProfileApi.data()

    {
      :ok,
      socket
      |> assign_user()
      |> clear_form()
      |> assign(profile: ProfileApi.fetch("ngumokenneth"))
      |> assign(profile: profile)
    }
  end

  def render(assigns) do
    ~H"""
    <div class=" text-white py-10 font-SpaceMono">
      <div class="mx-6">
        <h1>devfinder</h1>
      </div>

      <CustomComponent.search_form form={@form} />

      <.profile profile={@profile} />
    </div>
    """
  end

  def profile(assigns) do
    ~H"""
    <div class="font-SpaceMono">
      <div class="flex py-6 px-10 mx-6 my-8 rounded-sm bg-[#1E2A47] ">
        <div>
          <img src={@profile["avatar_url"]} alt="" class="rounded-full w-24" />
        </div>
        <div class="ml-6">
          <div class="flex justify-between">
            <div>
              <h2 class="font-bold"><%= @profile["name"] %></h2>
              <span class="my-2 flex block text-xs" data-role="profile">
                @<%= @profile["login"] %>
              </span>
            </div>
            <p class="text-sm"><%= "Joined  #{format_date(@profile["created_at"])}" %></p>
          </div>
          <p class="my-4 text-xs"><%= @profile["bio"] %></p>

          <div class="flex justify-between bg-[#141D2F] rounded-lg my-8 px-6 py-2">
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
          <div class="grid grid-cols-2 text-xs">
            <div class="flex">
              <CustomComponent.location_icon />
              <p class="ml-3 items-center"><%= @profile["location"] %></p>
            </div>
            <div class="flex  items-center justify-center">
              <CustomComponent.twitter_icon account_exist?={@profile["twitter_username"]} />
              <p class="ml-2">
                <%= if @profile["twitter_username"],
                  do: @profile["twitter_username"],
                  else: "not available" %>
              </p>
            </div>
            <div class="flex my-4 items-center ">
              <CustomComponent.link_icon />
              <p class="ml-2">
                <%= if @profile["blog"], do: @profile["blog"], else: "not available" %>
              </p>
            </div>
            <div class="flex  my-4 items-center justify-center">
              <CustomComponent.office_icon />
              <p class="ml-2"><%= @profile["company"] %></p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def assign_user(socket) do
    socket
    |> assign(:user, %ProfileChangeset{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.user
      |> ProfileChangeset.change_user()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event("validate", %{"profile_changeset" => profile_changeset_params}, socket) do
    form =
      %ProfileChangeset{}
      |> ProfileChangeset.change_user(profile_changeset_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("search_dev", %{"profile_changeset" => username}, socket) do
    {:noreply, assign(socket, :profile, ProfileApi.fetch(username["username"]))}
  end

  def format_date(date) do
    {:ok, date, _} = DateTime.from_iso8601(date)
    IO.inspect(date)

    date
    |> DateTime.to_date()
    |> IO.inspect(label: "date")
    |> Timex.format!("{D} {Mshort} {YYYY}")
  end
end
