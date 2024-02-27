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
  end

  scope "/api", ElixirPlaygroundApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/accounts", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end
end
