defmodule GithubUserSearchApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GithubUserSearchAppWeb.Telemetry,
      # Start the Ecto repository
      GithubUserSearchApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GithubUserSearchApp.PubSub},
      # Start Finch
      {Finch, name: GithubUserSearchApp.Finch},
      # Start the Endpoint (http/https)
      GithubUserSearchAppWeb.Endpoint
      # Start a worker by calling: GithubUserSearchApp.Worker.start_link(arg)
      # {GithubUserSearchApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GithubUserSearchApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GithubUserSearchAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
