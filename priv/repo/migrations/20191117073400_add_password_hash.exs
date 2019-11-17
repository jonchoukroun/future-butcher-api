defmodule FutureButcherApi.Repo.Migrations.AddPasswordHash do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :password_hash, :string
    end
  end
end
