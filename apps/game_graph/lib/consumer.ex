defmodule GameGraph.Consumer do
  @moduledoc """
  Subscribes to an event stream of games and calculates the new Elo scores of each game
  """
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def results(pid) do
    GenServer.call(pid, {:all_results})
  end

  def results(pid, player) do
    GenServer.call(pid, {:results, player})
  end

  def init(:ok) do
    {:consumer, Graph.new(type: :directed), subscribe_to: [GameLedger.Producer]}
  end

  def handle_call({:all_results}, _from, graph) do
    with  players <- Graph.vertices(graph),
          results <- players
            |> Enum.map(fn player ->
              {
                player,
                Graph.out_edges(graph, player)
                  |> Enum.map(fn edge -> %{opponent: edge.v2, games_played: edge.weight || 0} end),
                Graph.in_edges(graph, player)
                  |> Enum.map(fn edge -> %{opponent: edge.v1, games_played: edge.weight || 0} end),
              }
            end)
            |> Enum.reduce(%{}, fn ({player, wins, losses}, acc) -> Map.put(acc, player, %{ wins: wins, losses: losses}) end)
    do
      {:reply, results, [], graph}
    end
  end

  def handle_call({:results, player}, _from, graph) do
    wins = graph
      |> Graph.out_edges(player)
      |> Enum.map(fn edge -> %{opponent: edge.v2, games_played: edge.weight || 0} end)

    losses = graph
      |> Graph.in_edges(player)
      |> Enum.map(fn edge -> %{opponent: edge.v1, games_played: edge.weight || 0} end)

    {:reply, %{ wins: wins, losses: losses}, [], graph}
  end

  def handle_events(events, _from, state) do
    state = events
      |> Enum.map(fn {:game, winner, loser} -> {winner, loser} end)
      |> Enum.reduce(state, &GameGraph.Implementation.calculate/2)

    {:noreply, [], state}
  end
end
