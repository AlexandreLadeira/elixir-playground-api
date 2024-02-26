defmodule ElixirPlaygroundApiWeb.DefaultController do
  use ElixirPlaygroundApiWeb, :controller

  def index(conn, _params) do
    text(conn, "ElixirPlaygroundApi is up and running! - #{Mix.env()}")
  end
end
