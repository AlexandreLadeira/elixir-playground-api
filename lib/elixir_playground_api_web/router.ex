defmodule ElixirPlaygroundApiWeb.Router do
  use ElixirPlaygroundApiWeb, :router
  use Plug.ErrorHandler

  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{error: message}) |> halt()
  end

  defp handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{error: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug ElixirPlaygroundApiWeb.Auth.Pipeline
    plug ElixirPlaygroundApiWeb.Auth.SetAccount
  end

  scope "/api", ElixirPlaygroundApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/accounts", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  scope "/api", ElixirPlaygroundApiWeb do
    pipe_through [:api, :auth]
    get "/accounts/:id", AccountController, :show
    get "/logged_account/", AccountController, :show_from_session
    put "/accounts", AccountController, :update
    post "/accounts/sign_out", AccountController, :sign_out
    post "/accounts/refresh_session", AccountController, :refresh_session
  end
end
