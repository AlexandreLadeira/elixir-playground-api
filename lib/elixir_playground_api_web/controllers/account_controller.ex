defmodule ElixirPlaygroundApiWeb.AccountController do
  use ElixirPlaygroundApiWeb, :controller

  alias ElixirPlaygroundApi.{Accounts, Accounts.Account, Users, Users.User}
  alias ElixirPlaygroundApi.Accounts.Account
  alias ElixirPlaygroundApiWeb.Auth.{Guardian, ErrorResponse}

  plug :is_authorized_account when action in [:update, :delete]

  action_fallback ElixirPlaygroundApiWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> render(:account_token, %{account: account, token: token})
    end
  end

  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:account_token, %{account: account, token: token})

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Incorret email or password."
    end
  end

  def refresh_session(conn, %{}) do
    token = Guardian.Plug.current_token(conn)
    {:ok, account, new_token} = Guardian.authenticate(token)

    conn
    |> Plug.Conn.put_session(:account_id, account.id)
    |> put_status(:ok)
    |> render(:account_token, %{account: account, token: new_token})
  end

  def sign_out(conn, %{}) do
    account = conn.assigns[:account]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)

    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render(:account_token, %{account: account, token: nil})
  end

  defp is_authorized_account(conn, _opts) do
    %{params: %{"account" => account_params}} = conn
    account = Accounts.get_account!(account_params["id"])

    if(conn.assigns.account.id == account.id) do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def show_from_session(conn, _) do
    render(conn, :show, account: conn.assigns.account)
  end

  def update(conn, %{"account" => account_params}) do
    account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
