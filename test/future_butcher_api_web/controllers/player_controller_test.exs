defmodule FutureButcherApiWeb.PlayerControllerTest do
  use FutureButcherApiWeb.ConnCase

  alias FutureButcherApi.Auth
  alias FutureButcherApiWeb.Router.Helpers, as: Routes

  @create_attrs %{
    name: "jon",
    email: "jon@aol.com",
    password: "xxxxxx",
    password_confirmation: "xxxxxx"
  }
  @invalid_attrs %{}

  def fixture(:player) do
    {:ok, player} = Auth.create_player(@create_attrs)
    player
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create player" do
    test "renders player when data is valid", %{conn: conn} do
      assert Enum.count(Auth.list_players()) === 0

      conn = post(conn, Routes.player_path(conn, :create), player: @create_attrs)
      assert json_response(conn, 201)["jwt"]
      assert Enum.count(Auth.list_players()) === 1
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.player_path(conn, :create), player: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
