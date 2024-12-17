defmodule DeeperNetworkTest do
  use ExUnit.Case
  doctest DeeperNetwork

  test "greets the world" do
    assert DeeperNetwork.hello() == :world
  end
end
