defmodule FutureButcherApi.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias FutureButcherApi.{Repo, Player}
  alias FutureButcherApi.Guardian

  @type player() :: %Player{}
  @type changeset() :: Ecto.Changeset

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  @spec list_players() :: [player()]
  def list_players, do: Repo.all(Player)

  @doc """
  Gets a single player.

  Raises if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

  """
  @spec get_player!(integer()) :: player() | Ecto.NoResultsError
  def get_player!(id) do
    Player
    |> preload([:scores])
    |> Repo.get!(id)
  end

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, ...}

  """
  @spec create_player(map()) :: {:ok, player()} | {:error, atom()}
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, ...}

  """
  @spec delete_player(player()) :: {:ok, player()} | {:error, :atom}
  def delete_player(%Player{} = player), do: Repo.delete(player)

  @doc """
  Verifies a user's name and password and returns a JWT.

  Returns an error if either the user is not found by name, or the password is incorrect.
  """
  @spec token_sign_in(String.t(), String.t()) :: String.t() | {:error, :unauthorized}
  def token_sign_in(name, password) do
    case name_password_auth(name, password) do
      {:ok, player} ->
        Guardian.encode_and_sign(player)

      _ ->
        {:error, :unauthorized}
    end
  end

  defp name_password_auth(name, password) when is_binary(name) and is_binary(password) do
    with {:ok, player} <- get_by_name(name) do
      Argon2.check_pass(player, password)
    end
  end
  defp name_password_auth(_name, _password), do: {:error, :invalid_credentials}

  defp get_by_name(name) when is_binary(name) do
    Player
    |> preload([:scores])
    |> Repo.get_by(name: name)
    |> case do
      nil ->
        Argon2.no_user_verify()
        {:error, "Login error."}
      player ->
        {:ok, player}
    end
  end
end
