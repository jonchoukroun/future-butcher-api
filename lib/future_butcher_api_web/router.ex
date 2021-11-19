defmodule FutureButcherApiWeb.Router do
  use FutureButcherApiWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :fetch_session
    plug :fetch_live_flash
  end

  scope "/api", FutureButcherApiWeb do
    pipe_through :api
  end
end
