defmodule ElixirPlaygroundApiWeb.Auth.ErrorResponse.Unauthorized do
  defexception [:message, plug_status: 401]
end

defmodule ElixirPlaygroundApiWeb.Auth.ErrorResponse.Forbidden do
  defexception message: "Missing access to requested resource", plug_status: 403
end

defmodule ElixirPlaygroundApiWeb.Auth.ErrorResponse.NotFound do
  defexception message: "Not Found", plug_status: 404
end
