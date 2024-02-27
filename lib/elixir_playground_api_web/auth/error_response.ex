defmodule ElixirPlaygroundApiWeb.Auth.ErrorResponse.Unauthorized do
  defexception [:message, plug_status: 401]
end
