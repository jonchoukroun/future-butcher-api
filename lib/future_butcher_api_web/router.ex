defmodule FutureButcherApiWeb.Router do
  use FutureButcherApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FutureButcherApiWeb do
    pipe_through :api
  end
end
