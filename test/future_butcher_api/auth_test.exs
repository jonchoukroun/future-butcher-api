defmodule FutureButcherApi.AuthTest do
  use FutureButcherApi.DataCase

  alias FutureButcherApi.{Auth, Player}

  describe "players" do

    @valid_attrs %{
      name: "jon",
      password: "xxxxxx",
      password_confirmation: "xxxxxx"
    }
    @invalid_attrs %{}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Auth.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Auth.get_player!(player.id) == player
      assert Ecto.assoc_loaded?(player.scores)
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Auth.create_player(@valid_attrs)
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_player(@invalid_attrs)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Auth.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_player!(player.id) end
    end
  end
end
