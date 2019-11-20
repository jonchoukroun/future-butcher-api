defmodule FutureButcherApi.Repo.Migrations.AddUniqueConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:players, [:name])
    create unique_index(:players, [:email])
  end
end
