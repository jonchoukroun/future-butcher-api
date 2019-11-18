defmodule FutureButcherApiWeb.Auth.PlayerView do
  use FutureButcherApiWeb, :view

  def render("jwt.json", %{jwt: jwt}), do: %{jwt: jwt}

  def render("player.json", %{player: player}) do
    %{
      data: [
        type: "players",
        id: player.id,
        attributes: %{
          name: player.name,
          email: player.email
        },
        relationships: %{
          scores: %{
            count: Enum.count(player.scores)
          }
        }
      ]
    }
  end
end

