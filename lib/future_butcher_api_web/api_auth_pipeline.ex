defmodule FutureButcherApi.Guardian.ApiAuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :future_butcher_api,
    module: FutureButcherApi.Guardian,
    error_handler: FutureButcherApi.ApiAuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
