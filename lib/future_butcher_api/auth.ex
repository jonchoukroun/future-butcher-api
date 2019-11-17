defmodule FutureButcherApi.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias FutureButcherApi.{Repo, Player}

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
end
