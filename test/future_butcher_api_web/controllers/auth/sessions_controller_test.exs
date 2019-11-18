defmodule FutureButcherApiWeb.Auth.SessionsControllerTest do
  use FutureButcherApiWeb.ConnCase

  alias FutureButcherApi.Auth
  alias FutureButcherApiWeb.Router.Helpers, as: Routes

  @create_attrs %{
    name: "jon",
    password: "xxxxxx",
    password_confirmation: "xxxxxx"
  }
  @valid_login_attrs %{
    name: @create_attrs.name,
    password: @create_attrs.password
  }

  def fixture(:player) do
    {:ok, player} = Auth.create_player(@create_attrs)
    player
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create session" do
    setup [:create_player]

    test "returns error if player name is blank", %{conn: conn} do
      conn = post(conn, Routes.sessions_path(conn, :create), %{@valid_login_attrs | name: nil})
      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "returns error if player password is blank", %{conn: conn} do
      conn = post(conn, Routes.sessions_path(conn, :create), %{@valid_login_attrs | password: nil})
      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "returns unauthorized error if password is incorrect", %{conn: conn} do
      conn = post(conn, Routes.sessions_path(conn, :create), %{@valid_login_attrs | password: "yyyyyy"})
      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "returns unauthorized error if player does not exist", %{conn: conn} do
      invalid_credentials = %{name: "frank", password: "xxxxxx"}
      conn = post(conn, Routes.sessions_path(conn, :create), invalid_credentials)
      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "renders jwt when player name and password are correct", %{conn: conn} do
      conn = post(conn, Routes.sessions_path(conn, :create), @valid_login_attrs)
      assert json_response(conn, 200)["jwt"]
    end
  end

  defp create_player(_) do
    {:ok, player: fixture(:player)}
  end
end

