defmodule ConsumeHandler do

  require Logger

  def route_event({command, message}, finish_fun) do

    case command do
      "echo" ->
        echo_back(message)
      _ ->
        Logger.error(fn -> "Cannot handle command." end)
    end

    finish_fun.()
  end

  defp echo_back(message) do
    echo_message = ConsumeService.Echo.decode(message)

    IO.puts("msg: #{echo_message.message}")

    KafkaExGateway.Publisher.produce(
      echo_message.echo_target, "echo_back", echo_message.message)
  end
end
