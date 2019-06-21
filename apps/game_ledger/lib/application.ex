defmodule GameLedger.Application do
  use Application

  def start(_, _) do
    GameLedger.Supervisor.start_link()
  end
end
