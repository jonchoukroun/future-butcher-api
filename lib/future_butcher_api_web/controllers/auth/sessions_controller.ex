defmodule FutureButcherApiWeb.Auth.SessionsController do
  use FutureButcherApiWeb, :controller

  alias FutureButcherApi.Auth

  action_fallback FutureButcherApiWeb.Auth.FallbackController

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t() | {:error, :unauthorized}
  def create(conn, %{"name" => name, "password" => password}) do
    with {:ok, token, _claims} <- Auth.token_sign_in(name, password) do
      conn
      |> put_status(:ok)
      |> render("jwt.json", jwt: token)
    end
  end
end
