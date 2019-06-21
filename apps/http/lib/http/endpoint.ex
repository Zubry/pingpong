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

  get "/elo" do
    send_resp(conn, 200, Poison.encode!(%{"response" => Elo.all()}))
  end

  get "/elo/:player" do
    send_resp(conn, 200, Poison.encode!(%{"response" => Elo.get(player) }))
  end

  get "/results" do
    send_resp(conn, 200, Poison.encode!(%{"response" => GameGraph.results()}))
  end

  post "/match" do
    {status, body} = HTTP.Controller.Match.post(conn.body_params)

    send_resp(conn, status, body)
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "How did you end up here?")
  end
end
