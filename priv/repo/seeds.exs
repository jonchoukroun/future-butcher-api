defmodule FutureButcherApi.Seeder do
  alias FutureButcherApi.{Player, Score, Repo}

  def generate_name do
    Faker.Internet.user_name()
  end

  def insert_player do
    name = generate_name()
    Repo.insert! %Player{
      name:    name,
      hash_id: Enum.join([name, DateTime.utc_now()], "%%")
    }
  end

  def insert_score(%Player{id: player_id}) do
    Repo.insert! %Score{
      score: :rand.uniform(100000),
      player_id: player_id
    }
  end

end

players =
  (1..50)
  |> Enum.map(fn _ -> FutureButcherApi.Seeder.insert_player() end)

players
|> Enum.each(& FutureButcherApi.Seeder.insert_score(&1))
