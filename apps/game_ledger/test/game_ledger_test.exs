defmodule GameLedgerTest do
  use ExUnit.Case
  doctest GameLedger

  test "greets the world" do
    assert GameLedger.hello() == :world
  end
end
