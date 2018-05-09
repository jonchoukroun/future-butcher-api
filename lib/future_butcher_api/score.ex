defmodule FutureButcherApi.Score do
  use Ecto.Schema
  import Ecto.Changeset
  alias FutureButcherApi.Player


  schema "scores" do
    field :score, :integer

    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:score])
    |> validate_required([:score])
  end
end
