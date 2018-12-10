defmodule FutureButcherApiWeb.Router do
  use FutureButcherApiWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FutureButcherApiWeb do
    pipe_through :api
  end
end
