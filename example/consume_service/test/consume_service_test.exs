defmodule ConsumeServiceTest do
  use ExUnit.Case
  doctest ConsumeService

  test "greets the world" do
    assert ConsumeService.hello() == :world
  end
end
