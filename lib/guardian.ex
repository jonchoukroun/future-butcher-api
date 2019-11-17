defmodule FutureButcherApi.Guardian do
  use Guardian, otp_app: :future_butcher_api

  @spec subject_for_token(atom() | %{id: any}, any) :: {:ok, String.t()}
  def subject_for_token(player, _claims) do
    sub = to_string(player.id)
    {:ok, sub}
  end

  @spec resource_from_claims(Keyword.t() | map() | nil) :: {:ok, %FutureButcherApi.Player{}} | {:error, :resource_not_found}
  def resource_from_claims(claims) do
    id = claims["sub"]
    FutureButcherApi.Auth.get_player!(id)
    |> case do
      Ecto.NoResultsError ->
        {:error, :resource_not_found}

      player ->
        {:ok, player}
    end
  end
end
