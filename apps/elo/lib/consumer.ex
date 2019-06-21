defmodule Elo.Consumer do
  @moduledoc """
  Subscribes to an event stream of games and calculates the new Elo scores of each game
  """
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, %{}, subscribe_to: [GameLedger.Producer]}
  end

  def handle_events(events, _from, state) do
    state = events
      |> Enum.map(fn {:game, winner, loser} -> {winner, loser} end)
      |> Enum.reduce(state, &Elo.Implementation.calculate/2)

    {:noreply, [], state}
  end
end
