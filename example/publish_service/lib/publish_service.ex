defmodule PublishService do

  def start() do
    Supervisor.start_link([
      KafkaExGateway.Supervisor,
    ], strategy: :one_for_one)
  end
end
