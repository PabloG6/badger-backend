defmodule BadgerApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BadgerApiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BadgerApiWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{errors: _errors} = changeset}) do

    conn
      |> put_status(:unprocessable_entity)
      |> put_view(BadgerApiWeb.ChangesetView)
      |> render(:error, changeset: changeset)
  end

  def call(conn, %{message: message}) do
    conn
      |> put_status(:unauthorized)
      |> put_view(BadgerApiWeb.ErrorView)
      |> render(:"401", message: message)
  end





end
