defmodule KafkaExGateway.Stage.Consumer do
  @moduledoc """

  """
  use GenStage

  require Logger


  @default_demand_per_handler 10

  defstruct [
    :next_id,
    :producer,
    :producer_from,
    :pending_requests,
    :max_demand,
    :event_handler_mod
  ]

  # Client

  def start_link(producer) do
    GenStage.start_link(__MODULE__, producer)
  end

  # Server

  @impl GenStage
  def init(producer) do
    state = %__MODULE__{
      next_id: 0,
      producer: producer,
      producer_from: nil,
      pending_requests: %{},
      max_demand: Application.get_env(
        :kafka_ex_gateway,
        :max_demand_per_handler,
        @default_demand_per_handler
        ),
      event_handler_mod: Application.get_env(
        :kafka_ex_gateway,
        :event_handler_mod,
        KafkaExGateway.Stage.Consumer.DefaultEventHandlerMod
      )
    }

    send(self(), :init)

    {:consumer, state}
  end

  @impl GenStage
  def handle_info(:init, %{producer: producer} = state) do
    GenStage.async_subscribe(self(), to: producer, cancel: :temporary)
    {:noreply, [], state}
  end

  @impl GenStage
  def handle_info({:response, response}, state) do
    new_state = handle_response(response, state)
    {:noreply, [], new_state}
  end

  @impl GenStage
  def handle_info(unknown_msg, state) do
    Logger.info(fn -> "[#{__MODULE__}] Received unknown_msg - #{inspect unknown_msg}" end)
    {:noreply, state}
  end

  @impl GenStage
  def handle_subscribe(:producer, _opts, from, state) do
    GenStage.ask(from, state.max_demand)
    Logger.info(fn -> "[#{__MODULE__}] Subscribe to #{inspect from}" end)
    {:manual, %{state | producer_from: from}}
  end

  @impl GenStage
  def handle_events(messages, _from, state) do
    state = Enum.reduce(messages, state, &do_send/2)

    {:noreply, [], state}
  end

  defp do_send(message,
    %{pending_requests: pending_requests, event_handler_mod: event_handler_mod} = state)
  do
    {task_id, state} = generate_id(state)

    {status, decoded} = try do
      {:ok, Common.Message.decode(message)}
    rescue
      FunctionClauseError ->
        Logger.error(fn -> "[#{__MODULE__} Cannot analyze message" end)
        {:error, nil}
      _ ->
        Logger.error(fn -> "[#{__MODULE__} occured error!!!" end)
        {:error, nil}
    end

    case status do
      :ok ->
        command = decoded.meta.command
        payload = decoded.payload
        consumer = self()
        event_handler_mod.route_event({command, payload}, fn ->
          send(consumer, {:response, %{dispatch_id: task_id}})
        end)

        pending_requests = Map.put(pending_requests, task_id, decoded.meta.id)

        %{state | pending_requests: pending_requests}

      :error ->
        state
    end
  end

  defp handle_response(
         %{dispatch_id: dispatch_id} = _response,
         %{pending_requests: pending_requests,
         producer_from: producer_from,
         max_demand: max_demand} = state
       )
  do
    {_, pending_requests} = Map.pop(pending_requests, dispatch_id)
    if (map_size(pending_requests) <= 0), do: GenStage.ask(producer_from, max_demand)

    %{state | pending_requests: pending_requests}
  end

  defp generate_id(%{next_id: next_id} = state) do
    {to_string(next_id), %{state | next_id: next_id + 1}}
  end

  defmodule DefaultEventHandlerMod do
    def route_event({command, message}, finish_fun) do
      IO.puts("[DefaultEventHandlerMode] Received msg: #{inspect command} - #{inspect message}")
      finish_fun.()
    end
  end
end
