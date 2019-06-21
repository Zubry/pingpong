defmodule Elo.Implementation do
  @default_elo 1000
  @k 32

  def calculate({{winner, _winning_score}, {loser, _losing_score}}, elo) do
    with  r_1 <- Map.get(elo, winner, @default_elo),
          r_2 <- Map.get(elo, loser, @default_elo),
          er_1 <- :math.pow(10, r_1 / 400),
          er_2 <- :math.pow(10, r_2 / 400),
          e_1 <- er_1 / (er_1 + er_2),
          e_2 <- er_2 / (er_1 + er_2),
          s_1 <- 1,
          s_2 <- 0,
          rp_1 <- r_1 + @k * (s_1 - e_1),
          rp_2 <- r_2 + @k * (s_2 - e_2),
          rp_1 <- round(rp_1),
          rp_2 <- round(rp_2)
    do
      elo
        |> Map.put(winner, rp_1)
        |> Map.put(loser, rp_2)
    end
  end
end
