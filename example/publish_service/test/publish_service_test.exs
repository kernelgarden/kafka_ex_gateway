defmodule PublishServiceTest do
  use ExUnit.Case
  doctest PublishService

  test "greets the world" do
    assert PublishService.hello() == :world
  end
end
