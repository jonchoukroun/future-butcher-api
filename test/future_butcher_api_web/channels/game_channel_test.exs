defmodule FutureButcherApiWeb.GameChannelTest do
  use FutureButcherApiWeb.ChannelCase
  import Ecto.Query
  alias FutureButcherApiWeb.{GameChannel, UserSocket}
  alias FutureButcherApi.{Repo, Player, Score}

  describe "join" do
    test "join succeeds for new player" do
      player_name = "frank"
      assert {:ok, _payload, _socket} =
        socket(UserSocket)
        |> subscribe_and_join(
          GameChannel,
          "game:#{player_name}",
          %{"player_name" => player_name})
    end

    test "join fails when room has an existing player" do
      socket(UserSocket)
      |> subscribe_and_join(GameChannel, "game:alice", %{"player_name" => "alice"})

      assert {:error, %{reason: "Unauthorized"}} =
        socket(UserSocket)
        |> subscribe_and_join(GameChannel, "game:alice", %{"player_name" => "bob"})
    end

    test "re-join succeeds with valid hash id" do
      {:ok, %{hash_id: hash_id}, socket} =
        socket(UserSocket)
        |> subscribe_and_join(GameChannel, "game:alice", %{"player_name" => "alice"})

      Process.unlink(socket.channel_pid)
      ref = leave(socket)
      assert_reply ref, :ok

      assert {:ok, _payload, _socket} =
        socket(UserSocket)
        |> subscribe_and_join(GameChannel, "game:alice", %{
          "player_name" => "alice", "hash_id" => hash_id
        })
    end

    @tag :skip
    test "join fails with invalid payload" do
      assert {:error, %{reason: "Invalid payload"}} =
        socket(UserSocket)
        |> subscribe_and_join(GameChannel, "game:test", %{})
    end
  end

  describe "get_scores" do
    setup do
      {:ok, _, socket} =
        socket(UserSocket)
        |> subscribe_and_join(GameChannel, "game:bob", %{"player_name" => "bob"})

        %{socket: socket}
    end

    test "returns top scores", %{socket: socket} do
      ref = push(socket, "get_scores")
      assert_reply ref, :ok, %{state_data: state_data}
      assert is_list(state_data)
    end
  end

  describe "end_game" do
    setup do
      {:ok, _, socket} =
        socket(UserSocket)
        |> subscribe_and_join(GameChannel, "game:bob", %{"player_name" => "bob"})

      ref = push(socket, "new_game", %{})
      assert_reply ref, :ok
      ref = push(socket, "start_game", %{})
      assert_reply ref, :ok

      %{socket: socket}
    end

    test "does not persist score when lower than player's high score", %{socket: socket} do
      player = create_player(socket)
      Repo.insert!(%Score{score: 500, player_id: player.id})

      ref = push(socket, "end_game", %{score: 100, hash_id: player.hash_id})
      assert_reply ref, :ok, %{state_data: _state_data}

      player = Player |> preload(:scores) |> Repo.get(player.id)
      [%{score: score}] = player.scores
      assert score == 500

      cleanup(player)
    end

    test "does not persist score when score is nil", %{socket: socket} do
      player = create_player(socket)

      ref = push(socket, "end_game", %{score: nil, hash_id: player.hash_id})
      assert_reply ref, :ok, %{state_data: _state_data}

      player = Player |> preload(:scores) |> Repo.get(player.id)
      assert player.scores == []

      cleanup(player)
    end

    test "does not persist a score of 0", %{socket: socket} do
      player = create_player(socket)

      ref = push(socket, "end_game", %{score: 0, hash_id: player.hash_id})
      assert_reply ref, :ok, %{state_data: _state_data}

      player = Player |> preload(:scores) |> Repo.get(player.id)
      assert player.scores == []

      cleanup(player)
    end

    test "persists valid score", %{socket: socket} do
      player = create_player(socket)

      assert Enum.count(player.scores) == 0

      ref = push(socket, "end_game", %{score: 200, hash_id: player.hash_id})
      assert_reply ref, :ok, %{state_data: _state_data}

      score = Score |> Repo.get_by!(player_id: player.id)
      assert score.score == 200
      assert score.player_id == player.id

      cleanup(player)
    end

    test "replaces high score with new higher score", %{socket: socket} do
      player = create_player(socket)
      Repo.insert!(%Score{score: 400, player_id: player.id})

      player = Player |> preload(:scores) |> Repo.get(player.id)
      assert Enum.count(player.scores) == 1

      ref = push(socket, "end_game", %{score: 600, hash_id: player.hash_id})
      assert_reply ref, :ok, %{state_data: _state_data}

      player = Player |> preload(:scores) |> Repo.get(player.id)
      assert Enum.count(player.scores) == 1
      [%{score: score}] = player.scores
      assert score == 600

      cleanup(player)
    end

    test "replaces highest score with new higher score", %{socket: socket} do
      player = create_player(socket)
      Repo.insert!(%Score{score: 100, player_id: player.id})
      Repo.insert!(%Score{score: 200, player_id: player.id})

      player = Player |> preload(:scores) |> Repo.get(player.id)
      assert Enum.count(player.scores) == 2

      ref = push(socket, "end_game", %{score: 600, hash_id: player.hash_id})
      assert_reply ref, :ok, %{state_data: _state_data}

      player = Player |> preload(:scores) |> Repo.get(player.id)
      player.scores
      |> Enum.each(& assert &1.score in [100, 600])

      cleanup(player)
    end
  end

  defp create_player(socket) do
    "game:" <> player_name = socket.topic
    Player |> preload(:scores) |> Repo.get_by!(name: player_name)
  end

  defp cleanup(player) do
    Score |> where([s], s.player_id == ^player.id) |> Repo.delete_all()
    Repo.delete!(player)
  end
end
