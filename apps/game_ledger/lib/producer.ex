defmodule GameLedger.Producer do
  @moduledoc """
  Stores the results of all games. Fires a {:game, {winner, winning_score}, {loser, losing_score}} when a game is added
  """
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def record(pid, winner, loser, winning_score, losing_score)
      when winning_score >= 0 and losing_score >= 0 do
    GenServer.cast(pid, {:record, {winner, winning_score}, {loser, losing_score}})
  end

  def init(state) do
    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_cast({:record, winner, loser}, state) do
    {:noreply, [{:game, winner, loser}], [{:game, winner, loser}] ++ state}
  end

  def handle_demand(demand, state) do
    {:noreply, Enum.take(state, demand), state}
  end
end
