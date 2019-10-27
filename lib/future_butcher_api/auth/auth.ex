defmodule FutureButcherApi.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias FutureButcherApi.Repo

  alias FutureButcherApi.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Player
    |> preload([p], [:scores])
    |> Repo.all()
  end

  @doc """
  Gets a single player.

  Raises if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

  """
  def get_player!(id) do
    Player
    |> where([p], p.id == ^id)
    |> preload([p], [:scores])
    |> Repo.one!
  end

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, ...}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, ...}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, ...}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns a data structure for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Todo{...}

  """
  def change_player(%Player{} = player) do
    Player.changeset(player, %{})
  end

  @doc """
  Verifies a player based on their email and password.
  """
  @spec authenticate_player(email :: String.t, password :: String.t) :: EctoSchema.t | {:error, atom}
  def authenticate_player(email, password) when is_nil(email) or is_nil(password) do
    {:error, :invalid_auth_attributes}
  end

  def authenticate_player(email, password) do
    query = from(p in Player, where: p.email == ^email)
    query |> Repo.one() |> verify_password(password)
  end

  def signed_in?(conn), do: conn.assigns[:current_player]

  defp verify_password(nil, _), do: {:error, :incorrect_auth_credentials}
  defp verify_password(player, password) do
    if Bcrypt.verify_pass(password, player.password_hash) do
      {:ok, player}
    else
      {:error, :incorrect_auth_credentials}
    end
  end
end
