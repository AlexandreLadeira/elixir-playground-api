defmodule ElixirPlaygroundApi.Repo do
  use Ecto.Repo,
    otp_app: :elixir_playground_api,
    adapter: Ecto.Adapters.Postgres
end
