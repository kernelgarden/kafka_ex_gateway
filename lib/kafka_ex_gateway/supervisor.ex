defmodule KafkaExGateway.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts \\ []) do
    Logger.info(fn -> "Starting #{__MODULE__}..." end)
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    group_name = Keyword.fetch!(opts, :group_name)
    topic_name = Keyword.fetch!(opts, :topic_name)

    consumer_group_opts = [
      session_timeout: 10_000,
      heartbeat_interval: 3_000,
      commit_interval: 1_000,
    ]

    children = [
      %{
        id: KafkaEx.ConsumerGroup,
        start: {KafkaEx.ConsumerGroup, :start_link, [
          KafkaExGateway.KafkaConsumer,
          group_name,
          [topic_name],
          consumer_group_opts,
        ]},
        type: :supervisor
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
