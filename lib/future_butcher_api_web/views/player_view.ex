defmodule FutureButcherApiWeb.PlayerView do
  use FutureButcherApiWeb, :view
  alias FutureButcherApiWeb.PlayerView

  def render("jwt.json", %{jwt: jwt}), do: %{jwt: jwt}
end
