defmodule FutureButcherApiWeb.Auth.SessionsView do
  use FutureButcherApiWeb, :view

  def render("jwt.json", %{jwt: jwt}), do: %{jwt: jwt}
end

