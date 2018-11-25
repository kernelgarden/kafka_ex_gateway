defmodule KafkaExGateway.Stage.Producer do
  @moduledoc """
  This module collects messages from kafka and dispatch it to consumers
  """
  use GenStage

  require Logger

  @default_max_buffer_size 10_000
  @default_stage_consumer_size 10

  # Client

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def notify(message) do
    GenStage.cast(__MODULE__, {:notify, message})
  end

  # Server

  @impl GenStage
  def init(_args) do
    Logger.info(fn -> "Starting #{__MODULE__}..." end)
    send(self(), :init)

    {:producer,
     buffer_size:
       Application.get_env(
         :kafka_ex_gateway,
         :max_gen_stage_buffer_size,
         @default_max_buffer_size
       )}
  end

  @impl GenStage
  def handle_info(:init, state) do
    stage_consumer_size =
      Application.get_env(
        :kafka_ex_gateway,
        :gen_stage_consumer_size,
        @default_stage_consumer_size
      )

    Enum.each(1..stage_consumer_size, fn _ ->
      KafkaExGateway.Stage.ConsumerSupervisor.start_consumer(self())
    end)

    Logger.info(fn -> "Craete #{stage_consumer_size} stage consumers" end)
    {:noreply, [], state}
  end

  @impl GenStage
  def handle_cast({:notify, message}, state) do
    Logger.info(fn -> "Dispatch msg - #{message}" end)
    {:noreply, [message], state}
  end

  @impl GenStage
  def handle_demand(_imcomming_demand, state) do
    {:noreply, [], state}
  end
end
