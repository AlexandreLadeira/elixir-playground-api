defmodule ElixirPlaygroundApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :elixir_playground_api,
    module: ElixirPlaygroundApiWeb.Auth.Guardian,
    error_handler: ElixirPlaygroundApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
