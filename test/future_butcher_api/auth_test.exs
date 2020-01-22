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
      assert Enum.count(Auth.list_players()) === 0

      player_fixture()
      fetched_players = Auth.list_players()

      assert Enum.count(fetched_players) === 1
      assert List.first(fetched_players).name === @valid_attrs.name
      refute is_nil(List.first(fetched_players).password_hash)
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      fetched_player = Auth.get_player!(player.id)
      assert player.id === fetched_player.id
      assert player.name === fetched_player.name
      refute is_nil(fetched_player.password_hash)
      assert is_nil(fetched_player.password)
      assert is_nil(fetched_player.password_confirmation)
      assert Ecto.assoc_loaded?(fetched_player.scores)
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Auth.create_player(@valid_attrs)
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_player(@invalid_attrs)
    end

    test "create_player/1 with same name as existing player returns error changeset" do
      player_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.create_player(@valid_attrs)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Auth.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_player!(player.id) end
    end
  end
end
