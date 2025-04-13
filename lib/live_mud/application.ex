defmodule LiveMud.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveMudWeb.Telemetry,
      LiveMud.Repo,
      {DNSCluster, query: Application.get_env(:live_mud, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveMud.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveMud.Finch},
      # Start a worker by calling: LiveMud.Worker.start_link(arg)
      # {LiveMud.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveMudWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveMud.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveMudWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
