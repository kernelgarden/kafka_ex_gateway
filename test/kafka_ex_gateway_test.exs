defmodule KafkaExGatewayTest do
  use ExUnit.Case
  doctest KafkaExGateway

  test "greets the world" do
    assert KafkaExGateway.hello() == :world
  end
end
