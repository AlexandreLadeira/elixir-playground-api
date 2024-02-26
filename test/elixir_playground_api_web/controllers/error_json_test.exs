defmodule ElixirPlaygroundApiWeb.ErrorJSONTest do
  use ElixirPlaygroundApiWeb.ConnCase, async: true

  test "renders 404" do
    assert ElixirPlaygroundApiWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ElixirPlaygroundApiWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
