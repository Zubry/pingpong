defmodule GameGraph.Implementation do
  def calculate({{winner, _winning_score}, {loser, _losing_score}}, graph) do
    with  edge <- Graph.edge(graph, winner, loser),
          weight <- (if is_nil(edge), do: 1, else: edge.weight + 1),
          graph <- Graph.add_edge(graph, winner, loser, weight: weight)
    do
      graph
    end
  end
end
