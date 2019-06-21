defmodule GameGraph do
  @moduledoc """
  Documentation for GameGraph.
  """

  def results() do
    GameGraph.Consumer.results(GameGraph.Consumer)
  end

  def results(player) do
    GameGraph.Consumer.results(GameGraph.Consumer, player)
  end
end
