defmodule KafkaExGateway.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts \\ []) do
    Logger.info(fn -> "Starting #{__MODULE__}..." end)
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    #group_name = Application.get_env(:kafka_ex_gateway, :consumer_group_name)
    #topic_name = Application.get_env(:kafka_ex_gateway, :topic_name)
    group_name = "gate-tester-01"
    topic_name = "gate-test-01"

    consumer_group_opts = [
      session_timeout: 10_000,
      heartbeat_interval: 3_000,
      commit_interval: 1_000
    ]

    # First, starts consumer supervisor and producer of gen_stage
    # And then, starts kafka consumer group to subscribe kafka
    children = [
      %{
        id: KafkaExGateway.Stage.ConsumerSupervisor,
        start:
          {KafkaExGateway.Stage.ConsumerSupervisor, :start_link, []},
        type: :supervisor
      },
      %{
        id: KafkaExGateway.Stage.Producer,
        start:
          {KafkaExGateway.Stage.Producer, :start_link, []}
      },
      %{
        id: KafkaEx.ConsumerGroup,
        start:
          {KafkaEx.ConsumerGroup, :start_link,
           [
             KafkaExGateway.KafkaConsumer,
             group_name,
             [topic_name],
             consumer_group_opts
           ]},
        type: :supervisor
      },
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
