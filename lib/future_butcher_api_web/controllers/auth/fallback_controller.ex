defmodule FutureButcherApiWeb.Auth.FallbackController do
  use FutureButcherApiWeb, :controller
  alias FutureButcherApiWeb.ErrorHelpers

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors = Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: errors})
  end
end
