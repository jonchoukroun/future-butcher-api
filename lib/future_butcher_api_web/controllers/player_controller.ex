defmodule FutureButcherApiWeb.PlayerController do
  use FutureButcherApiWeb, :controller

  alias FutureButcherApi.{Auth, Player}

  def create(conn, %{"player" => player_params}) do
    with {:ok, %Player{} = player} <- Auth.create_player(player_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.player_path(conn, :show, player))
      |> render("show.json", player: player)
    end
  end
end
