defmodule FutureButcherApi.AuthTest do
  use FutureButcherApi.DataCase

  alias FutureButcherApi.Auth

  describe "players" do
    alias FutureButcherApi.Player

    @valid_attrs %{email: "jon@aol.com", name: "some name", password: "some password", }
    @update_attrs %{email: "bob@aol.com", name: "some updated name", password: "some updated password"}
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_player()

      %Player{player | password: nil, scores: []}
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Auth.list_players() == [player]
    end

    test "get_player!/1 returns the player from given id with preloaded scores" do
      player = player_fixture()
      assert player = Auth.get_player!(player.id)
      assert player.email == @valid_attrs.email
      assert player.name == @valid_attrs.name
      assert is_binary(player.password_hash)
      assert player.password == nil
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Auth.create_player(@valid_attrs)
      assert player.email == @valid_attrs.email
      assert player.name == @valid_attrs.name
      assert is_binary(player.password_hash)
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Auth.update_player(player, @update_attrs)
      assert player.email == @update_attrs.email
      assert player.name == @update_attrs.name
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_player(player, @invalid_attrs)
      assert player == Auth.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Auth.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Auth.change_player(player)
    end
  end
end
