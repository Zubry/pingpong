defmodule GameGraph.Application do
  use Application

  def start(_, _) do
    GameGraph.Supervisor.start_link()
  end
end
