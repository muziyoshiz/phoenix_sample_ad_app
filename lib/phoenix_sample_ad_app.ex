defmodule PhoenixSampleAdApp do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      # supervisor(PhoenixSampleAdApp.Repo, []),
      # Start the endpoint when the application starts
      supervisor(PhoenixSampleAdApp.Endpoint, []),
      # Start your own worker by calling: PhoenixSampleAdApp.Worker.start_link(arg1, arg2, arg3)
      # worker(PhoenixSampleAdApp.Worker, [arg1, arg2, arg3]),

      # Start Cachex
      # Cachex does not support LRU. If you need LRU, use Cachex.touch/2 on every gets.
      worker(Cachex, [ :ad_cache, [ limit: %Cachex.Limit{ limit: 10000, policy: Cachex.Policy.LRW, reclaim: 0.1 } ] ])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixSampleAdApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoenixSampleAdApp.Endpoint.config_change(changed, removed)
    :ok
  end
end
