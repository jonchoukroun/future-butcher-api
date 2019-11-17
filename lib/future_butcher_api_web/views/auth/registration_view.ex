defmodule FutureButcherApiWeb.Auth.RegistrationView do
  use FutureButcherApiWeb, :view

  def render("jwt.json", %{jwt: jwt}), do: %{jwt: jwt}
end