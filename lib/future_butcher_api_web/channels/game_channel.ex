defmodule FutureButcherApiWeb.GameChannel do
  use FutureButcherApiWeb, :channel
  import Ecto.Query
  alias FutureButcherEngine.{Game, GameSupervisor}
  alias FutureButcherApi.{Repo, Player, Score}
  alias FutureButcherApiWeb.Presence

  def join("game:" <> _player, %{"player_name" => name, "hash_id" => hash_id} = payload, socket) do
    if authorized?(socket) do
      send(self(), {:after_join, name})

      retrieve_player(payload)
      {:ok, %{hash_id: hash_id}, socket}
    else
      msg = "Unauthorized"
      Sentry.capture_message("Failed to re-join socket", extra: %{extra: msg})
      {:error, %{reason: msg}}
    end
  end

  def join("game:" <> _player, %{"player_name" => name} = payload, socket) do
    if authorized?(socket) do
      send(self(), {:after_join, name})

      player = persist_player(payload)
      {:ok, %{hash_id: player.hash_id}, socket}
    else
      msg = "Unauthorized"
      Sentry.capture_message("Failed to join socket", extra: %{extra: msg})
      {:error, %{reason: msg}}
    end
  end

  def join("game:" <> _player, _payload) do
    msg = "Invalid payload"
    Sentry.capture_message("Failed to join game", extra: %{extra: msg})
    {:error, %{reason: msg}}
  end

  def handle_info({:after_join, screen_name}, socket) do
    {:ok, _} = Presence.track(socket, screen_name, %{
      online_at: inspect(System.system_time(:seconds))
      })
    {:noreply, socket}
  end

  # Client callbacks ===========================================================

  def handle_in("get_scores", _payload, socket) do
    reply_success(retrieve_scores(), socket)
  end


  # Game management ------------------------------------------------------------

  def handle_in("new_game", _payload, socket) do
    "game:" <> player = socket.topic

    case GameSupervisor.start_game(player) do
      {:ok, _pid}      -> reply_success(:ok, socket)
      {:error, reason} -> reply_failure(reason, socket)
    end
  end

  def handle_in("restore_game_state", name, socket) do
    case GenServer.whereis(Game.via_tuple(name)) do
      nil  -> reply_failure("No existing process", socket)
      _pid ->
        :sys.get_state(Game.via_tuple(name))
        |> reply_success(socket)
    end
  end

  def handle_in("start_game", _payload, socket) do
    case Game.start_game(via(socket.topic)) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
    end
  end

  def handle_in("end_game", payload, socket) do
    "game:" <> player = socket.topic

    persist_score_if_valid(payload)

    case GameSupervisor.stop_game(player) do
      :ok              -> reply_success(retrieve_scores(100), socket)
      {:error, reason} -> reply_failure(reason, socket)
    end
  end


  # Transit --------------------------------------------------------------------

  def handle_in("change_station", payload, socket) do
    %{"destination" => destination} = payload
    destination = String.to_existing_atom(destination)

    case Game.change_station(via(socket.topic), destination) do
      {:ok, state_data}        -> reply_success(state_data, socket)
      {:game_over, state_data} -> {:reply, {:game_over, state_data}, socket}
      {:error, reason}         -> reply_failure(reason, socket)
      error                    -> reply_failure(error, socket)
    end
  end

  def handle_in("fight_mugger", _payload, socket) do
    case Game.fight_mugger(via(socket.topic)) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end

  def handle_in("bribe_mugger", _payload, socket) do
    case Game.bribe_mugger(via(socket.topic)) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end


  # Loans/debt -----------------------------------------------------------------

  def handle_in("pay_debt", _payload, socket) do
    case Game.pay_debt(via(socket.topic)) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end


  # Weapons/items --------------------------------------------------------------

  def handle_in("buy_pack", %{"pack" => pack}, socket) do
    pack = String.to_existing_atom(pack)

    case Game.buy_pack(via(socket.topic), pack) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end

  def handle_in("buy_weapon", %{"weapon" => weapon}, socket) do
    weapon = String.to_existing_atom(weapon)

    case Game.buy_weapon(via(socket.topic), weapon) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end

  def handle_in("replace_weapon", %{"weapon" => weapon}, socket) do
    weapon = String.to_existing_atom(weapon)

    case Game.replace_weapon(via(socket.topic), weapon) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end

  def handle_in("drop_weapon", _payload, socket) do
    case Game.drop_weapon(via(socket.topic)) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end

  # Buy/sell cuts --------------------------------------------------------------

  def handle_in("buy_cut", payload, socket) do
    %{"cut" => cut, "amount" => amount} = payload
    cut    = String.to_existing_atom cut
    amount = format_integer amount

    case Game.buy_cut(via(socket.topic), cut, amount) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end

  def handle_in("sell_cut", payload, socket) do
    %{"cut" => cut, "amount" => amount} = payload
    cut    = String.to_existing_atom cut
    amount = format_integer amount

    case Game.sell_cut(via(socket.topic), cut, amount) do
      {:ok, state_data} -> reply_success(state_data, socket)
      {:error, reason}  -> reply_failure(reason, socket)
      error             -> reply_failure(error, socket)
    end
  end


  # Validations ----------------------------------------------------------------

  defp number_of_players(socket) do
    socket
    |> Presence.list()
    |> Map.keys()
    |> length()
  end

  defp authorized?(socket) do
    number_of_players(socket) == 0
  end


  # Data formatting ------------------------------------------------------------

  defp format_integer(int) when is_binary(int), do: String.to_integer(int)
  defp format_integer(int) when is_integer(int), do: int


  # DB calls -------------------------------------------------------------------

  defp retrieve_player(%{"player_name" => name, "hash_id" => hash_id}) do
    Repo.get_by!(Player, %{hash_id: hash_id, name: name})
  end

  defp persist_player(%{"player_name" => name}) do
    hash_id = generate_player_hash(name)
    Repo.insert!(%Player{name: name, hash_id: hash_id})
  end

  defp generate_player_hash(name) when is_binary(name) do
    raw = Enum.join([name, DateTime.utc_now()], "%%")
    :crypto.hash(:sha256, raw) |> Base.encode64
  end

  defp retrieve_scores(), do: retrieve_scores(100)

  defp retrieve_scores(limit) when is_integer(limit) do
    Repo.all from s in Score,
              join: p in assoc(s, :player),
              order_by: [desc: s.score],
              limit:    ^limit,
              select:   %{player: p.name, score: s.score}
  end

  defp persist_score_if_valid(%{"score" => score}) when is_nil(score), do: :ok

  defp persist_score_if_valid(%{"score" => score, "hash_id" => hash_id}) do
    player = Repo.get_by(Player, %{hash_id: hash_id})
    Repo.insert!(%Score{score: score, player_id: player.id});
  end

  defp persist_score_if_valid(_payload), do: :ok


  # Utilities ------------------------------------------------------------------

  defp via("game:" <> player), do: Game.via_tuple(player)

  defp reply_success(state_data, socket), do: {:reply, {:ok, %{state_data: state_data}}, socket}

  defp reply_failure(reason, socket), do: {:reply, {:error, %{reason: inspect(reason)}}, socket}

end
