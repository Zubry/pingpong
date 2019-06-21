defmodule Elo.Application do
  use Application

  def start(_, _) do
    Elo.Supervisor.start_link()
  end
end
