defmodule FutureButcherApiWeb.Auth.SessionsControllerTest do
  use FutureButcherApiWeb.ConnCase

  import FutureButcherApi.Guardian

  alias FutureButcherApi.Auth

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

    test "returns error if player name is blank" do
      conn = json_conn()
      |> post("api/v1/sign_in", %{@valid_login_attrs | name: nil})

      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "returns error if player password is blank" do
      conn = json_conn()
      |> post("api/v1/sign_in", %{@valid_login_attrs | password: nil})

      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "returns unauthorized error if password is incorrect" do
      conn = json_conn()
      |> post("api/v1/sign_in", %{@valid_login_attrs | password: "yyyyyy"})

      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "returns unauthorized error if player does not exist" do
      invalid_credentials = %{name: "frank", password: "xxxxxx"}

      conn = json_conn()
      |> post("api/v1/sign_in", invalid_credentials)

      assert json_response(conn, :unauthorized)["errors"] === "Login error"
    end

    test "renders jwt when player name and password are correct" do
      conn = json_conn()
      |> post("api/v1/sign_in", @valid_login_attrs)

      assert json_response(conn, 200)["jwt"]
    end
  end

  describe "delete session" do
    test "when signed out returns error", %{conn: _conn} do
      conn = json_conn()
      |> delete("/api/v1/sign_out")

      assert json_response(conn, :unauthorized)["error"] === "unauthenticated"
    end

    test "when signed in returns no content", %{conn: _conn} do
      player = fixture(:player)
      {:ok, token, _claims} = encode_and_sign(player, %{}, token_type: :access)

      conn = json_conn()
      |> put_req_header("authorization", "bearer " <> token)
      |> delete("/api/v1/sign_out")

      assert json_response(conn, :no_content)
    end
  end

  defp json_conn do
    build_conn()
    |> put_resp_content_type("application/json")
  end

  defp create_player(_) do
    {:ok, player: fixture(:player)}
  end
end

