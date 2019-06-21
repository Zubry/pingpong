defmodule HTTP.Controller.Match do
  def post(%{ "winner" => winner, "loser" => loser, "winning_score" => winning_score, "losing_score" => losing_score})
    when byte_size(winner) > 1 and byte_size(loser) > 1 do
    case GameLedger.record(winner, loser, winning_score, losing_score) do
      :ok -> %{response: "ok"}
        |> HTTP.View.Match.successful()
    end
  end

  def post(_) do
    %{error: "Expected Payload: { 'winner': id, 'winning_score': int, 'loser': id, 'losing_score': int }"}
      |> HTTP.View.Match.error
  end
end
