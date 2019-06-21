defmodule HTTP.View.Match do
  def successful(response) do
    {200, Poison.encode!(response)}
  end

  def error(response) do
    {422, Poison.encode!(response)}
  end
end
