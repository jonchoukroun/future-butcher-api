# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FutureButcherApi.Repo.insert!(%FutureButcherApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule FutureButcherApi.Seeder do
  alias FutureButcherApi.{Player, Score, Repo}
  import Faker

  def generate_name do
    Faker.Internet.user_name()
  end

  def insert_player do
    name = generate_name()
    Repo.insert! %Player{
      name:    name,
      email:   Faker.Internet.email(),
      hash_id: Enum.join([name, Ecto.DateTime.utc], "%%")
    }
  end

  def insert_score do
    Repo.insert! %Score{
      score: :rand.uniform(100000),
      player_id: :rand.uniform(25)
    }
  end

end

(1..25) |> Enum.each fn _ -> FutureButcherApi.Seeder.insert_player end
(1..200) |> Enum.each fn _ -> FutureButcherApi.Seeder.insert_score end
