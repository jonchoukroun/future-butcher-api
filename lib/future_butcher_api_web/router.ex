defmodule FutureButcherApiWeb.Router do
  use FutureButcherApiWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", FutureButcherApiWeb do
    pipe_through :api

    resources "/sign_up", PlayerController, only: [:create]
  end
end
