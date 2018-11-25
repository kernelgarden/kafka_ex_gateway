defmodule KafkaExGateway.Stage.ConsumerSupervisor do
  @moduledoc """
  This module supervise consumers of gen_stage.
  """

  use DynamicSupervisor

  # TODO: To make this module scaling dynamically

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_consumer(producer) do
    DynamicSupervisor.start_child(
      __MODULE__,
      # {KafkaExGateway.Stage.Consumer, [producer]}
      %{
        id: KafkaExGateway.Stage.Consumer,
        start: {KafkaExGateway.Stage.Consumer, :start_link, [producer]}
      }
    )
  end

  @impl DynamicSupervisor
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
