defmodule Immortal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ImmortalWeb.Telemetry,
      Immortal.Repo,
      {DNSCluster, query: Application.get_env(:immortal, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Immortal.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Immortal.Finch},
      # Start a worker by calling: Immortal.Worker.start_link(arg)
      # {Immortal.Worker, arg},
      # Start to serve requests, typically the last entry
      ImmortalWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Immortal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ImmortalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
