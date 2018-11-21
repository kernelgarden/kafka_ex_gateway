defmodule KafkaExGateway.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    kafka_supervisor_opts = [
      group_name: "gate-tester-01",
      topic_name: "gate-test-01"
    ]

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: KafkaExGateway.Worker.start_link(arg)
      # {KafkaExGateway.Worker, arg},
      %{
        id: KafkaExGateway.Supervisor,
        start: {KafkaExGateway.Supervisor, :start_link, [kafka_supervisor_opts]},
        type: :supervisor
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KafkaExGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
