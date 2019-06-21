defmodule HTTP.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)
  # responsible for matching routes
  plug(:match)
  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  # responsible for dispatching responses
  plug(:dispatch)

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  get "/results" do
    send_resp(conn, 200, Poison.encode!(GameGraph.results()))
  end

  # Handle incoming events, if the payload is the right shape, process the
  # events, otherwise return an error.
  post "/match" do
    IO.inspect(conn.body_params)
    {status, body} =
      case conn.body_params do
        %{
          "winner" => winner,
          "loser" => loser,
          "winning_score" => winning_score,
          "losing_score" => losing_score,
        } -> process_match(winner, loser, winning_score, losing_score)
        _ -> {422, missing_match()}
      end

    send_resp(conn, status, body)
  end

  defp process_match(winner, loser, winning_score, losing_score) do
    # Do some processing on a list of events
    case GameLedger.record(winner, loser, winning_score, losing_score) do
      :ok -> {200, Poison.encode!(%{response: "ok"})}
    end
  end

  defp missing_match do
    Poison.encode!(%{error: "Expected Payload: {
      'winner': id,
      'winning_score': int,
      'loser': id,
      'losing_score': int,
    }"})
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "How did you end up here?")
  end
end
