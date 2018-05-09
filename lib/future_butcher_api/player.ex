defmodule FutureButcherApi.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias FutureButcherApi.Score


  schema "players" do
    field :email, :string
    field :hash_id, :string
    field :name, :string

    has_many :scores, Score

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :email])
    |> unique_constraint(:hash_id)
    |> unique_constraint(:email)
    |> validate_required([:name])
    |> validate_format(:email, ~r/@/)
  end
end
