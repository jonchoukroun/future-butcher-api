defmodule FutureButcherApiWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "game:*", FutureButcherApiWeb.GameChannel

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
