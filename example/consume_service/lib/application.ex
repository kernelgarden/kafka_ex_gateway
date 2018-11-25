defmodule ConsumeService.Application do
  use Application

  def start(_type, _args) do
    Supervisor.start_link([
      KafkaExGateway.Supervisor,
    ], strategy: :one_for_one)
  end
end
