defmodule FutureButcherApiWeb.PlayerController do
  use FutureButcherApiWeb, :controller

  alias FutureButcherApi.{Auth, Player, Guardian}

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"player" => player_params}) do
    with {:ok, %Player{} = player} <- Auth.create_player(player_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(player) do
      conn
      |> render("jwt.json", %{jwt: token})
    end
  end
end
