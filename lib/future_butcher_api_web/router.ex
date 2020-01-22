defmodule FutureButcherApiWeb.Router do
  use FutureButcherApiWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  alias FutureButcherApi.Guardian.ApiAuthPipeline

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_protected do
    plug ApiAuthPipeline
  end

  scope "/api/v1", FutureButcherApiWeb do
    pipe_through :api

    post "/sign_up", Auth.PlayerController, :create

    post "/sign_in", Auth.SessionsController, :create
  end

  scope "/api/v1", FutureButcherApiWeb do
    pipe_through [:api, :api_protected]

    delete "/sign_out", Auth.SessionsController, :delete

    get "/current_player", Auth.PlayerController, :show
  end
end
