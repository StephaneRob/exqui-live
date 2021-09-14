defmodule ExquiLiveTest do
  use ExUnit.Case
  doctest ExquiLive

  test "greets the world" do
    assert ExquiLive.hello() == :world
  end
end
