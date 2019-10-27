defmodule FutureButcherApi.Repo.Migrations.RemoveHashIdFromPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      remove :hash_id
    end
  end
end
