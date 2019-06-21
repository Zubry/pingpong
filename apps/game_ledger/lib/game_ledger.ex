defmodule GameLedger do
  def record(winner, loser, winning_score, losing_score) do
    GameLedger.Producer.record(GameLedger.Producer, winner, loser, winning_score, losing_score)
  end
end
