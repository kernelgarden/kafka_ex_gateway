defmodule KafkaExGateway.KafkaConsumer do
  @doc """
  use one kafka partition per one BEAM node
  """

  use KafkaEx.GenConsumer

  require Logger

  alias KafkaEx.Protocol.Fetch.Message
  alias KafkaExGateway.Stage.Producer

  def init(topic, partition) do
    Logger.info(fn ->
      "#{__MODULE__} is connected to #{topic} - #{partition}"
    end)

    {:ok, {topic, partition}}
  end

  def handle_message_set(message_set, {topic, partition} = state) do
    for %Message{value: message} <- message_set do
      # IO.puts("Received msg from #{topic} - #{partition}, msg: #{inspect(message)}")
      # dispatch to gen_stage
      Producer.notify(message)
    end

    {:async_commit, state}
  end
end
