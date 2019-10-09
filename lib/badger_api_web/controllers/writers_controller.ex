defmodule BadgerApiWeb.WritersController do
  use BadgerApiWeb, :controller

  alias BadgerApi.Accounts.Writer

  alias BadgerApi.Accounts
  action_fallback BadgerApiWeb.FallbackController

  def index(conn, _params) do
    writer = Accounts.list_writers()
    render(conn, "index.json", writer: writer)
  end

  def create(conn, %{"writers" => writer_params}) do
    with {:ok, %Writer{} = writer} <- Accounts.create_writer(writer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.writers_path(conn, :show, writer))
      |> render("show.json", writer: writer)
    end
  end

  def show(conn, %{"id" => id}) do
    writer = Accounts.get_writer!(id)
    render(conn, "show.json", writer: writer)
  end

  def update(conn, %{"id" => id, "writers" => writer_params}) do
    writer = Accounts.get_writer!(id)

    with {:ok, %Writer{} = writer} <- Accounts.update_writer(writer, writer_params) do
      render(conn, "show.json", writer: writer)
    end
  end

  def delete(conn, %{"id" => id}) do
    writer = Accounts.get_writer!(id)

    with {:ok, %Writer{}} <- Accounts.delete_writer(writer) do
      send_resp(conn, :no_content, "")
    end
  end

  def signup(conn, %{"writers" => writer_params}) do
    with {:ok, %Writer{} = writer} <- Accounts.create_writer(writer_params) do
      conn
      |> put_status(:created)
      |> login_reply(writer)
    end
  end

  def login(conn, %{"identifier" => identifier, "password" => password}) do
    with {:ok, writer} <-
           BadgerApi.Accounts.authenticate_writer(%{identifier: identifier, password: password}) do
      conn
      |> put_status(:ok)
      |> login_reply(writer)
    else
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(BadgerApiWeb.ErrorView)
        |> render(:"401", message: message)
    end
  end

  defp login_reply(conn, writer) do
    token =
      BadgerApi.Auth.Guardian.Plug.sign_in(conn, writer)
      |> BadgerApi.Auth.Guardian.Plug.current_token()

    conn
    |> put_session(:current_writer_id, writer.id)
    |> put_view(BadgerApiWeb.WritersView)
    |> render(:login, writers: writer, token: token)
  end
end
