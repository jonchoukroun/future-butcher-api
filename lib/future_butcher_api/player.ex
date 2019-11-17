defmodule FutureButcherApi.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias FutureButcherApi.Score


  schema "players" do
    field :email, :string
    field :name, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :scores, Score

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :password, :password_confirmation])
    |> unique_constraint(:name)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.add_hash(password))

      _ ->
        changeset
    end
  end
end
