defmodule FutureButcherApiWeb.Auth.PlayerControllerTest do
  use FutureButcherApiWeb.ConnCase

  alias FutureButcherApi.Auth
  alias FutureButcherApiWeb.Router.Helpers, as: Routes

  @create_attrs %{
    name: "jon",
    email: "jon@aol.com",
    password: "xxxxxx",
    password_confirmation: "xxxxxx"
  }
  @sign_in_attrs %{
    name: @create_attrs.name,
    password: @create_attrs.password
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

  describe "show player when not signed in" do
    setup [:create_player]

    test "returns unauthorized error" do
      conn = build_conn()
      |> put_resp_content_type("application/json")
      |> get("/api/v1/current_player")

      assert json_response(conn, :unauthorized)["error"] === "unauthenticated"
    end
  end

  describe "show player when signed in" do
    setup [:create_player, :sign_in_player]

    test "returns player struct", %{jwt: jwt} do
      conn = build_conn()
      |> put_resp_content_type("application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/v1/current_player")

      assert json_response(conn, :ok)["data"] === %{
        "name" => @create_attrs.name,
        "email" => @create_attrs.email,
        "scores" => []
      }
    end
  end

  defp create_player(_) do
    {:ok, player: fixture(:player)}
  end

  defp sign_in_player(_) do
    conn = build_conn()
    |> put_resp_content_type("application/json")
    |> post("/api/v1/sign_in", @sign_in_attrs)
    jwt = json_response(conn, :ok)["jwt"]

    {:ok, conn: conn, jwt: jwt}
  end
end
