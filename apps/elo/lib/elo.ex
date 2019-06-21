defmodule Elo do
  def get(player) do
    Elo.Consumer.get(Elo.Consumer, player)
  end

  def all() do
    Elo.Consumer.all(Elo.Consumer)
  end
end
