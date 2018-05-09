defmodule FutureButcherApi.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :email, :string
      add :hash_id, :string

      timestamps()
    end

  end
end
