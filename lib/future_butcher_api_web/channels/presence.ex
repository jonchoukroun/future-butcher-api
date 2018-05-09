defmodule FutureButcherApiWeb.Presence do
  use Phoenix.Presence, otp_app: :future_butcher_api,
    pubsub_server: FutureButcherApi.PubSub
end
