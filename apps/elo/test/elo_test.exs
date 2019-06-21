defmodule EloTest do
  use ExUnit.Case

  test "Calculates ELO correctly when the favorite wins" do
    elo = %{
      :james => 2400,
      :kate => 2000,
    }

    elo = Elo.Implementation.calculate({{:james, 2}, {:kate, 1}}, elo)

    assert Map.get(elo, :james) == 2403
    assert Map.get(elo, :kate) == 1997
  end

  test "Calculates ELO correctly when the underdog wins" do
    elo = %{
      :james => 2400,
      :kate => 2000,
    }

    elo = Elo.Implementation.calculate({{:kate, 2}, {:james, 1}}, elo)

    assert Map.get(elo, :james) == 2371
    assert Map.get(elo, :kate) == 2029
  end
end
