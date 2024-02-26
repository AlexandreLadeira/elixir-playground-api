defmodule ElixirPlaygroundApiWeb.Router do
  use ElixirPlaygroundApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirPlaygroundApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
  end
end
